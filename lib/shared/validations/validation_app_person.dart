import 'package:trip_planner/entities/entity_person.dart';
import 'package:trip_planner/shared/errors/error_app_person.dart';

/// Validation rules for travel group members.
abstract final class AppPersonRules {
  /// Validates a group member.
  static AppPersonError? validatePerson(Person person) {
    if (person.name.trim().isEmpty) {
      return AppPersonError.nameRequired;
    }

    if (person.age < 0) {
      return AppPersonError.invalidAge;
    }

    return null;
  }
}
