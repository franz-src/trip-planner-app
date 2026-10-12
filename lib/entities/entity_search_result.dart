import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

/// Represents a destination returned by location search.
@immutable
final class SearchResult {
  /// Default constructor.
  const SearchResult({required this.displayName, required this.position});

  /// Display name of the destination.
  final String displayName;

  /// Geographic coordinates of the destination.
  final LatLng position;

  /// Returns a [SearchResult] based on the given JSON.
  factory SearchResult.fromJSON(Map<String, dynamic> json) {
    return SearchResult(
      displayName: json['display_name'],
      position: LatLng(double.parse(json['lat']), double.parse(json['lon'])),
    );
  }

  /// Returns a JSON based on this [SearchResult].
  Map<String, dynamic> toJSON() => {
    'display_name': displayName,
    'lat': position.latitude.toString(),
    'lon': position.longitude.toString(),
  };

  /// Returns a copy with the given fields replaced.
  SearchResult copyWith({String? displayName, LatLng? position}) =>
      SearchResult(
        displayName: displayName ?? this.displayName,
        position: position ?? this.position,
      );
}
