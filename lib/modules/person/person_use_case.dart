import 'package:trip_planner/entities/entity_person.dart';
import 'package:trip_planner/entities/entity_result.dart';
import 'package:trip_planner/modules/person/person_spec.dart';
import 'package:trip_planner/shared/errors/error_person.dart';
import 'package:trip_planner/shared/validations/validation_person.dart';

PersonUseCase newPersonUseCase() => const _PersonUseCase();

class _PersonUseCase implements PersonUseCase {
  const _PersonUseCase();

  @override
  Result<Person, PersonError> createPerson(String name, String age) {
    if (name.trim().isEmpty) {
      return Result.failure(PersonError.nameRequired);
    }

    if (age.trim().isEmpty) {
      return Result.failure(PersonError.ageRequired);
    }

    final parsedAge = int.tryParse(age.trim());
    if (parsedAge == null) {
      return Result.failure(PersonError.invalidAge);
    }

    final person = Person(name: name.trim(), age: parsedAge);
    final error = PersonRules.validatePerson(person);
    if (error != null) {
      return Result.failure(error);
    }

    return Result.success(person);
  }
}
