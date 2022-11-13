import 'package:faker/faker.dart';
import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_core/src/contexts/communities/domain/entities/member.dart';
import 'package:surpraise_core/surpraise_core.dart';
import 'package:test/test.dart';

class CommunityRepository extends Mock
    implements RemoveMembersRepository, FindCommunityRepository {}

void main() {
  late RemoveMembersUsecase sut;
  late CommunityRepository communityRepository;
  late RemoveMembersInput input;
  group("Remove Members Usecase: ", () {
    setUpAll(() {
      communityRepository = CommunityRepository();
      sut = DbRemoveMembersUsecase(
        removeMembersRepository: communityRepository,
        findCommunityRepository: communityRepository,
        eventBus: StreamEventBus(),
      );
      input = RemoveMembersInput(
        communityId: faker.guid.guid(),
        memberIds: [
          faker.guid.guid(),
          faker.guid.guid(),
          faker.guid.guid(),
        ],
      );
      registerFallbackValue(input);
      registerFallbackValue(
        FindCommunityInput(id: input.communityId),
      );
    });

    void mockFindCommunity(Either<Exception, FindCommunityOutput> value) =>
        when(
          () => communityRepository.find(
            any(),
          ),
        ).thenAnswer(
          (invocation) async => value,
        );

    void mockRemoveMembers(Either<Exception, RemoveMembersOutput> value) =>
        when(
          () => communityRepository.removeMembers(
            any(),
          ),
        ).thenAnswer(
          (invocation) async => value,
        );

    test("Should return left when trying to remove 0 members from a community",
        () async {
      final result = await sut(
        RemoveMembersInput(
          communityId: faker.guid.guid(),
          memberIds: [],
        ),
      );

      expect(result.isLeft(), isTrue);
    });

    test("Should return left when find Repo does so", () async {
      mockFindCommunity(
        Left(
          Exception(),
        ),
      );

      final result = await sut(input);

      expect(result.isLeft(), isTrue);
    });

    test(
        "Should return left when trying to instantiate an invalid value object",
        () async {
      mockFindCommunity(
        Right(
          FindCommunityOutput(
            id: faker.guid.guid(),
            ownerId: faker.guid.guid(),
            members: [],
            description: "",
            title: faker.lorem.word(),
          ),
        ),
      );

      final result = await sut(input);

      expect(result.isLeft(), isTrue);
    });

    test("Should return right when everything goes ok", () async {
      mockFindCommunity(
        Right(
          FindCommunityOutput(
            id: faker.guid.guid(),
            ownerId: faker.guid.guid(),
            members: [
              FindCommunityMemberDto(
                id: faker.guid.guid(),
                communityId: faker.guid.guid(),
                role: Role.member.name,
              )
            ],
            description: faker.lorem.words(3).toString(),
            title: faker.lorem.word(),
          ),
        ),
      );
      mockRemoveMembers(
        Right(
          RemoveMembersOutput(),
        ),
      );

      final result = await sut(input);

      expect(result.isRight(), isTrue);
    });

    // Always let this at the end of the file
    test("Should return left when giving invalid ids as param", () async {
      mockFindCommunity(
        Right(
          FindCommunityOutput(
            id: faker.guid.guid(),
            ownerId: faker.guid.guid(),
            members: [],
            description: faker.lorem.word(),
            title: faker.lorem.word(),
          ),
        ),
      );
      input.memberIds.clear();
      input.memberIds.add("");

      final result = await sut(input);

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l, (r) => null), isA<ValidationException>());
    });
  });
}
