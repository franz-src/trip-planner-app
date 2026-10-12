import 'package:flutter/foundation.dart';
import 'package:trip_planner/entities/entity_person.dart';
import 'package:trip_planner/entities/entity_stop.dart';

/// Represents a trip and its itinerary.
@immutable
final class Trip {
  /// Default constructor.
  const Trip({
    this.id,
    this.userId,
    required this.title,
    required this.transport,
    required this.startDate,
    required this.endDate,
    this.mapImage,
    this.concluded = false,
    this.group = const [],
    this.stops = const [],
  });

  /// Database identifier of the trip.
  final int? id;

  /// Identifier of the trip's owner.
  final int? userId;

  /// Title of the trip.
  final String title;

  /// Means of transport for the trip.
  final String transport;

  /// Start date of the trip.
  final String startDate;

  /// End date of the trip.
  final String endDate;

  /// Map image of the trip.
  final Uint8List? mapImage;

  /// Whether the trip has been concluded.
  final bool concluded;

  /// Members of the travel group.
  final List<Person> group;

  /// Stops in itinerary order.
  final List<Stop> stops;

  /// Returns a [Trip] based on the given JSON.
  factory Trip.fromJSON(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      transport: json['transport'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      mapImage: json['map_image'],
      concluded: json['concluded'] == 1,
    );
  }

  /// Returns a JSON based on this [Trip].
  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'transport': transport,
      'start_date': startDate,
      'end_date': endDate,
      'map_image': mapImage,
      'concluded': switch (concluded) {
        true => 1,
        false => 0,
      },
    };
  }

  /// Returns a copy with the given fields replaced.
  Trip copyWith({
    int? id,
    int? userId,
    String? title,
    String? transport,
    String? startDate,
    String? endDate,
    Uint8List? mapImage,
    bool? concluded,
    List<Person>? group,
    List<Stop>? stops,
  }) {
    return Trip(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      transport: transport ?? this.transport,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      mapImage: mapImage ?? this.mapImage,
      concluded: concluded ?? this.concluded,
      group: group ?? this.group,
      stops: stops ?? this.stops,
    );
  }
}
