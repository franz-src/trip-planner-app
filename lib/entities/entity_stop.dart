import 'package:flutter/foundation.dart';
import 'package:trip_planner/entities/entity_stop_experience.dart';

/// Represents a stop in a trip's itinerary.
@immutable
final class Stop {
  /// Default constructor.
  const Stop({
    this.id,
    this.tripId,
    required this.location,
    this.img,
    required this.startDate,
    required this.endDate,
    required this.latitude,
    required this.longitude,
    this.stopExperiences = const [],
  });

  /// Database identifier of the stop.
  final int? id;

  /// Identifier of the associated trip.
  final int? tripId;

  /// Name of the destination.
  final String location;

  /// Image path or URL of the destination.
  final String? img;

  /// Arrival date of the stop.
  final String startDate;

  /// Departure date of the stop.
  final String endDate;

  /// Latitude of the destination.
  final double latitude;

  /// Longitude of the destination.
  final double longitude;

  /// Experiences recorded at the stop.
  final List<StopExperience> stopExperiences;

  /// Returns a [Stop] based on the given JSON.
  factory Stop.fromJSON(Map<String, dynamic> json) {
    return Stop(
      id: json['id'],
      tripId: json['trip_id'],
      location: json['location'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  /// Returns a JSON based on this [Stop].
  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'trip_id': tripId,
      'location': location,
      'start_date': startDate,
      'end_date': endDate,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Returns a copy with the given fields replaced.
  Stop copyWith({
    int? id,
    int? tripId,
    String? location,
    String? img,
    String? startDate,
    String? endDate,
    double? latitude,
    double? longitude,
    List<StopExperience>? stopExperiences,
  }) {
    return Stop(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      location: location ?? this.location,
      img: img ?? this.img,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      stopExperiences: stopExperiences ?? this.stopExperiences,
    );
  }
}
