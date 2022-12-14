import 'package:faker/faker.dart';
import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_core/surpraise_core.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements InactivateUserRepository {}

void main() {
  late InactivateUserRepository inactivateUserRepository;
  late InactivateUserUsecase sut;
  final InactivateUserInput input = InactivateUserInput(
    id: faker.guid.guid(),
  );

  setUp(() {
    inactivateUserRepository = MockUserRepository();
    sut = DbInactivateUserUsecase(
      inactivateUserRepository: inactivateUserRepository,
      eventBus: StreamEventBus(),
    );
    registerFallbackValue(input);
  });

  void mockInactivate(Either<Exception, InactivateUserOutput> value) {
    when(() => inactivateUserRepository.inactivate(any()))
        .thenAnswer((invocation) async => value);
  }

  group("Inactivate User Usecase: ", () {
    test("Should return left when repository does so", () async {
      mockInactivate(
        Left(
          Exception(),
        ),
      );

      final result = await sut(input);

      expect(result.isLeft(), isTrue);
    });

    test("Should return left when input.id is invalid", () async {
      mockInactivate(
        Left(
          Exception(),
        ),
      );

      final result = await sut(InactivateUserInput(id: "asuhasu"));

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l, (r) => r), isA<ValidationException>());
    });

    test("Should return right when repository does so", () async {
      mockInactivate(
        Right(
          InactivateUserOutput(),
        ),
      );

      final result = await sut(input);

      expect(result.isRight(), isTrue);
    });
  });
}
