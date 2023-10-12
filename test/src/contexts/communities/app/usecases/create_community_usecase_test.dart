import 'package:faker/faker.dart';
import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart'
    hide equals;
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_core/surpraise_core.dart';
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
      imageUrl: faker.lorem.word(),
    );

    final ownerId = faker.guid.guid();
    final communityId = faker.guid.guid();
    final output = CreateCommunityOutput(
      id: communityId,
      title: faker.lorem.word(),
      description: faker.lorem.words(5).toString(),
      ownerId: ownerId,
      members: [
        {
          "id": ownerId,
          "role": "admin",
          "community_id": communityId,
        }
      ],
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
          imageUrl: faker.lorem.word(),
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
          imageUrl: faker.lorem.word(),
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
      mockCreateCommunity(
        Right(
          output,
        ),
      );

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

    test(
        "Should contains at least one member when creating a community, which needs to be the owner",
        () async {
      mockIdGeneration(faker.guid.guid());
      mockCreateCommunity(
        Right(
          output,
        ),
      );

      final result = await sut(
        validInput,
      );

      expect(
        result.isRight(),
        isTrue,
      );
      result.fold((l) => null, (r) {
        expect(
          r,
          isA<CreateCommunityOutput>(),
        );
        expect(
          r.members.isNotEmpty,
          isTrue,
        );
        expect(
          r.members.first["id"],
          equals(r.ownerId),
        );
      });
    });
  });
}
