import 'package:trip_planner/entities/entity_person.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/shared/errors/error_app_person.dart';

/// Interface for managing travel group members.
abstract class AppPersonUseCase {
  /// Creates a validated member from form values.
  Result<Person, AppPersonError> createPerson(String name, String age);
}
