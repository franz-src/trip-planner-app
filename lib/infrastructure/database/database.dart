import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trip_planner/infrastructure/database/persons_table.dart';
import 'package:trip_planner/infrastructure/database/stops_table.dart';
import 'package:trip_planner/infrastructure/database/trips_table.dart';
import 'package:trip_planner/infrastructure/database/user_experiences_table.dart';
import 'package:trip_planner/infrastructure/database/users_table.dart';

/// Class to manage the database connection.
class TripPlannerDatabase {
  /// Default constructor.
  TripPlannerDatabase();

  /// The database instance.
  Future<Database>? _connection;

  /// A getter for the database instance.
  Future<Database> get connection => _connection ??= _initDatabase().catchError(
    (Object error, StackTrace stack) {
      _connection = null;
      Error.throwWithStackTrace(error, stack);
    },
  );

  /// Initializes the database.
  Future<Database> _initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'trip_planner.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await UsersTable.createTable(db);
        await TripsTable.createTable(db);
        await PersonsTable.createTable(db);
        await StopsTable.createTable(db);
        await UserExperiencesTable.createTable(db);
      },
    );
  }
}
