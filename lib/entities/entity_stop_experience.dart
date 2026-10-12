import 'package:flutter/foundation.dart';

/// Represents an experience recorded at a trip stop.
@immutable
final class StopExperience {
  /// Default constructor.
  const StopExperience({this.id, this.stopId, required this.experience});

  /// Database identifier of the experience.
  final int? id;

  /// Identifier of the associated stop.
  final int? stopId;

  /// Text describing the experience.
  final String experience;

  /// Returns a [StopExperience] based on the given JSON.
  factory StopExperience.fromJSON(Map<String, dynamic> json) {
    return StopExperience(
      id: json['id'],
      stopId: json['stop_id'],
      experience: json['experience'],
    );
  }

  /// Returns a JSON based on this [StopExperience].
  Map<String, dynamic> toJSON() {
    return {'id': id, 'stop_id': stopId, 'experience': experience};
  }

  /// Returns a copy with the given fields replaced.
  StopExperience copyWith({int? id, int? stopId, String? experience}) {
    return StopExperience(
      id: id ?? this.id,
      stopId: stopId ?? this.stopId,
      experience: experience ?? this.experience,
    );
  }
}
