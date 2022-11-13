import 'package:faker/faker.dart';
import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_core/src/contexts/users/app/boundaries/edit_user_boundaries.dart';
import 'package:surpraise_core/src/contexts/users/app/usecases/edit_user_usecase.dart';
import 'package:surpraise_core/src/contexts/users/data/protocols/edit_user_repository.dart';
import 'package:surpraise_core/src/contexts/users/data/usecases/db_edit_user_usecase.dart';
import 'package:surpraise_core/src/core/exceptions/validation_exception.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements EditUserRepository {}

void main() {
  late EditUserRepository editUserRepository;
  late EditUserUsecase sut;

  final EditUserInput input = EditUserInput(
    tag: "@fake",
    name: "fake user",
    email: faker.internet.email(),
    id: faker.guid.guid(),
  );

  setUp(() {
    editUserRepository = MockUserRepository();
    sut = DbEditUserUsecase(editUserRepository: editUserRepository);
    registerFallbackValue(input);
  });

  void mockEdit(Either<Exception, EditUserOutput> value) {
    when(
      () => editUserRepository.edit(
        any(),
      ),
    ).thenAnswer((invocation) async => value);
  }

  group("Edit User Usecase: ", () {
    test("Should return left when repository does so", () async {
      mockEdit(
        Left(
          Exception(),
        ),
      );

      final result = await sut(input);

      expect(result.isLeft(), isTrue);
    });

    test("Should return left when an receiving invalid input", () async {
      mockEdit(
        Left(
          Exception(),
        ),
      );

      final result = await sut(
        EditUserInput(tag: "", name: "", email: "", id: ""),
      );

      expect(result.isLeft(), isTrue);
      expect(
        result.fold((l) => l, (r) => r),
        isA<ValidationException>(),
      );
    });

    test("Should return right when repository does so", () async {
      mockEdit(
        Right(
          EditUserOutput(
            tag: input.tag,
            name: input.name,
            email: input.email,
            id: input.id,
          ),
        ),
      );

      final result = await sut(input);

      expect(result.isRight(), isTrue);
    });
  });
}
