import 'package:flutter/foundation.dart';

/// Represents a member of a trip's travel group.
@immutable
final class Person {
  /// Default constructor.
  const Person({this.id, this.tripId, required this.name, required this.age});

  /// Database identifier of the person.
  final int? id;

  /// Identifier of the associated trip.
  final int? tripId;

  /// Name of the person.
  final String name;

  /// Age of the person.
  final int age;

  /// Returns a [Person] based on the given JSON.
  factory Person.fromJSON(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      tripId: json['trip_id'],
      name: json['name'],
      age: json['age'],
    );
  }

  /// Returns a JSON based on this [Person].
  Map<String, dynamic> toJSON() {
    return {'id': id, 'trip_id': tripId, 'name': name, 'age': age};
  }

  /// Returns a copy with the given fields replaced.
  Person copyWith({int? id, int? tripId, String? name, int? age}) {
    return Person(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }
}
