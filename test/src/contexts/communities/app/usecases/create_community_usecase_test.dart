import 'package:faker/faker.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/create_community_boundaries.dart';
import 'package:surpraise_core/src/contexts/communities/app/usecases/create_community_usecase.dart';
import 'package:surpraise_core/src/contexts/communities/data/protocols/create_community_repository.dart';
import 'package:surpraise_core/src/contexts/communities/data/usecases/db_create_community_usecase.dart';
import 'package:surpraise_core/src/core/exceptions/exceptions.dart';
import 'package:surpraise_core/src/core/protocols/services/id_service.dart';
import 'package:test/test.dart';

class MockCommunityRepository extends Mock
    implements CreateCommunityRepository {}

class MockIdService extends Mock implements IdService {}

void main() {
  late CreateCommunityUsecase sut;
  late CreateCommunityRepository createCommunityRepository;
  late IdService idService;

  void mockIdGeneration(String id) {
    when(() => idService.generate()).thenAnswer(
      (_) async => id,
    );
  }

  void mockCreateCommunity(Either<Exception, CreateCommunityOutput> value) {
    when(
      () => createCommunityRepository.createCommunity(
        any(),
      ),
    ).thenAnswer(
      (_) async => value,
    );
  }

  group("Create Community Usecase: ", () {
    final validInput = CreateCommunityInput(
      description: faker.lorem.sentences(2).toString(),
      ownerId: faker.guid.guid(),
      title: faker.lorem.word(),
    );
    setUp(() {
      idService = MockIdService();
      createCommunityRepository = MockCommunityRepository();
      sut = DbCreateCommunityUsecase(
        createCommunityRepository: createCommunityRepository,
        idService: idService,
      );
      registerFallbackValue(validInput);
    });

    test("Should return a left when idService throws", () async {
      when(() => idService.generate()).thenThrow(
        Exception(),
      );
      final result = await sut(
        CreateCommunityInput(
          description: faker.lorem.sentences(2).toString(),
          ownerId: faker.guid.guid(),
          title: faker.lorem.word(),
        ),
      );

      expect(
        result.isLeft(),
        isTrue,
      );
    });

    test(
        "Should return a left when community entity throws a validation exception",
        () async {
      mockIdGeneration(faker.guid.guid());

      final result = await sut(
        CreateCommunityInput(
          description: "",
          ownerId: faker.guid.guid(),
          title: faker.lorem.word(),
        ),
      );

      expect(
        result.isLeft(),
        isTrue,
      );
      expect(
        result.fold((l) => l, (r) => null),
        isA<ValidationException>(),
      );
    });

    test("Should return left when repository does so", () async {
      mockIdGeneration(faker.guid.guid());
      mockCreateCommunity(Left(Exception()));

      final result = await sut(
        validInput,
      );

      expect(
        result.isLeft(),
        isTrue,
      );
      expect(
        result.fold((l) => l, (r) => null),
        isA<Exception>(),
      );
    });

    test("Should return right when repository does so", () async {
      mockIdGeneration(faker.guid.guid());
      mockCreateCommunity(Right(CreateCommunityOutput()));

      final result = await sut(
        validInput,
      );

      expect(
        result.isRight(),
        isTrue,
      );
      expect(
        result.fold((l) => null, (r) => r),
        isA<CreateCommunityOutput>(),
      );
      verify(
        () => createCommunityRepository.createCommunity(
          any(),
        ),
      ).called(1);
    });
  });
}
