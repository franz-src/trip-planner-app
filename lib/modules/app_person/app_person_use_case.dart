import 'package:trip_planner/entities/entity_person.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/modules/app_person/app_person_spec.dart';
import 'package:trip_planner/shared/errors/error_app_person.dart';
import 'package:trip_planner/shared/validations/validation_app_person.dart';

AppPersonUseCase newAppPersonUseCase() => const _AppPersonUseCase();

class _AppPersonUseCase implements AppPersonUseCase {
  const _AppPersonUseCase();

  @override
  Result<Person, AppPersonError> createPerson(String name, String age) {
    if (name.trim().isEmpty) {
      return Result.failure(AppPersonError.nameRequired);
    }

    if (age.trim().isEmpty) {
      return Result.failure(AppPersonError.ageRequired);
    }

    final parsedAge = int.tryParse(age.trim());
    if (parsedAge == null) {
      return Result.failure(AppPersonError.invalidAge);
    }

    final person = Person(name: name.trim(), age: parsedAge);
    final error = AppPersonRules.validatePerson(person);
    if (error != null) {
      return Result.failure(error);
    }

    return Result.success(person);
  }
}
