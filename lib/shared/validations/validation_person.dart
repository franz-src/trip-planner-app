import 'package:trip_planner/entities/entity_person.dart';
import 'package:trip_planner/shared/errors/error_person.dart';

/// Validation rules for travel group members.
abstract final class PersonRules {
  /// Validates a group member.
  static PersonError? validatePerson(Person person) {
    if (person.name.trim().isEmpty) {
      return PersonError.nameRequired;
    }

    if (person.age < 0) {
      return PersonError.invalidAge;
    }

    return null;
  }
}
