import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trip_planner/entities/entity_person.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/entities/entity_stop.dart';
import 'package:trip_planner/entities/entity_stop_experience.dart';
import 'package:trip_planner/entities/entity_trip.dart';
import 'package:trip_planner/infrastructure/database/database.dart';
import 'package:trip_planner/modules/trip/trip_spec.dart';
import 'package:trip_planner/shared/errors/error_trip.dart';

TripRepository newTripRepository(TripPlannerDatabase database) {
  return _TripRepository(database);
}

class _TripRepository implements TripRepository {
  const _TripRepository(this._database);

  final TripPlannerDatabase _database;

  Future<List<int>> _saveRows(
    Transaction transaction,
    String table,
    String parentColumn,
    int parentId,
    List<Map<String, dynamic>> rows,
  ) async {
    final existing = await transaction.query(
      table,
      columns: ['id'],
      where: '$parentColumn = ?',
      whereArgs: [parentId],
    );
    final existingIds = existing.map((row) => row['id'] as int).toSet();
    final retainedIds = <int>{};
    final savedIds = <int>[];

    for (final source in rows) {
      final row = Map<String, dynamic>.from(source);
      final id = row.remove('id') as int?;
      row[parentColumn] = parentId;
      if (id == null) {
        savedIds.add(await transaction.insert(table, row));
      } else {
        if (!existingIds.contains(id) || !retainedIds.add(id)) {
          throw StateError('A related identifier does not belong to this trip');
        }

        await transaction.update(
          table,
          row,
          where: 'id = ? AND $parentColumn = ?',
          whereArgs: [id, parentId],
        );
        savedIds.add(id);
      }
    }

    for (final id in existingIds.difference(retainedIds)) {
      if (table == 'stops') {
        await transaction.delete(
          'user_experiences',
          where: 'stop_id = ?',
          whereArgs: [id],
        );
      }

      await transaction.delete(
        table,
        where: 'id = ? AND $parentColumn = ?',
        whereArgs: [id, parentId],
      );
    }

    return savedIds;
  }

  Future<void> _updateRelatedInformation(
    Transaction transaction,
    int tripId,
    Trip trip,
  ) async {
    await _saveRows(
      transaction,
      'persons',
      'trip_id',
      tripId,
      trip.group.map((person) => person.toJSON()).toList(),
    );
    final stopIds = await _saveRows(
      transaction,
      'stops',
      'trip_id',
      tripId,
      trip.stops.map((stop) => stop.toJSON()).toList(),
    );
    for (var index = 0; index < trip.stops.length; index++) {
      await _saveRows(
        transaction,
        'user_experiences',
        'stop_id',
        stopIds[index],
        trip.stops[index].stopExperiences
            .map((experience) => experience.toJSON())
            .toList(),
      );
    }
  }

  Map<String, dynamic> _tripRow(Trip trip) {
    final row = trip.toJSON();
    row['map_image'] = trip.mapImage ?? Uint8List(0);

    return row;
  }

  Future<void> _addRelatedInformation(
    Transaction transaction,
    int tripId,
    Trip trip,
  ) async {
    for (final person in trip.group) {
      final row = person.toJSON()..remove('id');
      row['trip_id'] = tripId;
      await transaction.insert('persons', row);
    }

    for (final stop in trip.stops) {
      final row = stop.toJSON()..remove('id');
      row['trip_id'] = tripId;
      final stopId = await transaction.insert('stops', row);

      for (final experience in stop.stopExperiences) {
        final row = experience.toJSON()..remove('id');
        row['stop_id'] = stopId;
        await transaction.insert('user_experiences', row);
      }
    }
  }

  Future<void> _deleteRelatedInformation(
    Transaction transaction,
    int tripId,
  ) async {
    await transaction.delete(
      'user_experiences',
      where: 'stop_id IN (SELECT id FROM stops WHERE trip_id = ?)',
      whereArgs: [tripId],
    );
    await transaction.delete(
      'persons',
      where: 'trip_id = ?',
      whereArgs: [tripId],
    );
    await transaction.delete(
      'stops',
      where: 'trip_id = ?',
      whereArgs: [tripId],
    );
  }

  @override
  Future<Result<int, TripError>> addTrip(Trip trip) async {
    try {
      final connection = await _database.connection;
      final id = await connection.transaction((transaction) async {
        final row = _tripRow(trip)..remove('id');
        final tripId = await transaction.insert('trips', row);
        await _addRelatedInformation(transaction, tripId, trip);

        return tripId;
      });

      return Result.success(id);
    } catch (e) {
      return Result.failure(TripError.unexpected);
    }
  }

  @override
  Future<Result<void, TripError>> updateTrip(Trip trip) async {
    try {
      final connection = await _database.connection;
      return await connection.transaction((transaction) async {
        final row = _tripRow(trip)..remove('id');
        final updated = await transaction.update(
          'trips',
          row,
          where: 'id = ? AND user_id = ?',
          whereArgs: [trip.id, trip.userId],
        );
        if (updated == 0) {
          return Result<void, TripError>.failure(TripError.notFound);
        }

        await _updateRelatedInformation(transaction, trip.id!, trip);

        return Result<void, TripError>.success(null);
      });
    } catch (e) {
      return Result.failure(TripError.unexpected);
    }
  }

  @override
  Future<Result<void, TripError>> deleteTrip(int id, int userId) async {
    try {
      final connection = await _database.connection;
      return await connection.transaction((transaction) async {
        final existing = await transaction.query(
          'trips',
          where: 'id = ? AND user_id = ?',
          whereArgs: [id, userId],
          limit: 1,
        );
        if (existing.isEmpty) {
          return Result<void, TripError>.failure(TripError.notFound);
        }

        await _deleteRelatedInformation(transaction, id);
        await transaction.delete(
          'trips',
          where: 'id = ? AND user_id = ?',
          whereArgs: [id, userId],
        );

        return Result<void, TripError>.success(null);
      });
    } catch (e) {
      return Result.failure(TripError.unexpected);
    }
  }

  @override
  Future<Result<List<Trip>, TripError>> getAllTrips(int userId) async {
    try {
      final connection = await _database.connection;
      final trips = await connection.transaction((transaction) async {
        final rows = await transaction.query(
          'trips',
          where: 'user_id = ?',
          whereArgs: [userId],
          orderBy: 'id',
        );
        final trips = <Trip>[];

        for (final row in rows) {
          final trip = Trip.fromJSON(row);
          final members = await transaction.query(
            'persons',
            where: 'trip_id = ?',
            whereArgs: [trip.id],
            orderBy: 'id',
          );
          final destinations = await transaction.query(
            'stops',
            where: 'trip_id = ?',
            whereArgs: [trip.id],
            orderBy: 'id',
          );
          final stops = <Stop>[];

          for (final row in destinations) {
            final stop = Stop.fromJSON(row);
            final experiences = await transaction.query(
              'user_experiences',
              where: 'stop_id = ?',
              whereArgs: [stop.id],
              orderBy: 'id',
            );
            stops.add(
              stop.copyWith(
                stopExperiences: experiences
                    .map(StopExperience.fromJSON)
                    .toList(),
              ),
            );
          }

          trips.add(
            trip.copyWith(
              group: members.map(Person.fromJSON).toList(),
              stops: stops,
            ),
          );
        }

        return trips;
      });

      return Result.success(trips);
    } catch (e) {
      return Result.failure(TripError.unexpected);
    }
  }
}
