import 'package:faker/faker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_core/src/contexts/users/app/boundaries/create_user_boundaries.dart';
import 'package:surpraise_core/src/contexts/users/app/usecases/create_user_usecase.dart';
import 'package:surpraise_core/src/contexts/users/data/protocols/create_user_repository.dart';
import 'package:surpraise_core/src/contexts/users/data/usecases/db_create_user_usecase.dart';
import 'package:surpraise_core/src/core/exceptions/validation_exception.dart';
import 'package:surpraise_core/src/core/protocols/services/id_service.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements CreateUserRepository {}

class MockIdService extends Mock implements IdService {}

void main() {
  late CreateUserUsecase sut;
  late CreateUserRepository createUserRepository;
  late IdService idService;

  group("Create User Usecase: ", () {
    final id = faker.guid.guid();
    final input = CreateUserInput(
      id: id,
      tag: "@mock",
      name: "Mocked User",
      email: faker.internet.email(),
    );
    void mockIdService() {
      when(
        () => idService.generate(),
      ).thenAnswer((invocation) async => id);
    }

    setUp(
      () {
        idService = MockIdService();
        createUserRepository = MockUserRepository();
        sut = DbCreateUserUsecase(
          createUserRepository: createUserRepository,
          idService: idService,
        );
        registerFallbackValue(input);
        mockIdService();
      },
    );

    void mockCreate(Either<Exception, CreateUserOutput> value) => when(
          () => createUserRepository.create(any()),
        ).thenAnswer(
          (invocation) async => value,
        );

    test("Should return left when repository does so", () async {
      mockCreate(
        Left(
          Exception(),
        ),
      );

      final result = await sut(input);

      expect(result.isLeft(), isTrue);
    });

    test("Should return right when repository does so", () async {
      mockCreate(
        Right(
          CreateUserOutput(
            email: input.email,
            name: input.name,
            tag: input.tag,
            id: id,
          ),
        ),
      );

      final result = await sut(input);

      expect(result.isRight(), isTrue);
    });

    test("Shuld return left when user instance throws", () async {
      mockCreate(
        Right(
          CreateUserOutput(
            email: input.email,
            name: input.name,
            tag: input.tag,
            id: id,
          ),
        ),
      );

      final result = await sut(
        CreateUserInput(tag: "", name: "", email: ""),
      );

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l, (r) => r), isA<ValidationException>());
    });
  });
}
