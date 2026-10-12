import 'package:trip_planner/entities/entity_person.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/shared/errors/error_person.dart';

/// Interface for managing travel group members.
abstract class PersonUseCase {
  /// Creates a validated member from form values.
  Result<Person, PersonError> createPerson(String name, String age);
}
