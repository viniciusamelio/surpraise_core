import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/contexts/communities/domain/entities/member.dart';
import 'package:surpraise_core/surpraise_core.dart';
import 'package:test/test.dart';

class CommunityRepository extends Mock
    implements AddMembersRepository, FindCommunityRepository {}

void main() {
  late AddMembersUsecase sut;
  late CommunityRepository communityRepository;
  late String inputId;
  late AddMembersInput input;

  group("Add Members Usecase: ", () {
    setUpAll(() {
      inputId = faker.guid.guid();
      input = AddMembersInput(
        idCommunity: inputId,
        members: [
          MemberToAdd(
            idMember: faker.guid.guid(),
            role: Role.member.name,
          )
        ],
      );
      communityRepository = CommunityRepository();
      sut = DbAddMembersUsecase(
        addMembersRepository: communityRepository,
        findCommunityRepository: communityRepository,
        eventBus: StreamEventBus(),
      );
    });

    setUp(() {
      registerFallbackValue(
        FindCommunityInput(
          id: inputId,
        ),
      );
      registerFallbackValue(
        input,
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

    void mockAddMembersRepo(Either<Exception, AddMembersOutput> value) => when(
          () => communityRepository.addMembers(
            any(),
          ),
        ).thenAnswer(
          (invocation) async => value,
        );

    test("Should return left when findCommunityRepo does so", () async {
      mockFindCommunity(
        Left(
          Exception("Community Not Found"),
        ),
      );

      final result = await sut(input);

      expect(result.isLeft(), isTrue);
    });

    test("Should return left when addMembersRepo does so", () async {
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
      mockAddMembersRepo(
        Left(
          Exception("Random exception"),
        ),
      );

      final result = await sut(input);

      expect(result.isLeft(), isTrue);
    });

    test("Should return left when trying to add an empty list of members",
        () async {
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

      final result = await sut(
        input..members.clear(),
      );

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l, (r) => null), isA<ApplicationException>());
    });

    test(
        "Should return left when trying to add more members than community's plan offers",
        () async {
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
      for (var i = 0; i < 100; i++) {
        input.members.add(
          MemberToAdd(
            idMember: faker.guid.guid(),
            role: Role.member.name,
          ),
        );
      }

      final result = await sut(input);

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l, (r) => null), isA<DomainException>());
    });

    test("Should return right when everything goes ok", () async {
      input.members.clear();
      input.members.add(
        MemberToAdd(idMember: faker.guid.guid(), role: Role.moderator.name),
      );
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
      mockAddMembersRepo(
        Right(
          AddMembersOutput(),
        ),
      );

      final result = await sut(input);

      expect(result.isRight(), isTrue);
    });

    test("Should return left when trying to instantiate an invalid community",
        () async {
      mockFindCommunity(
        Right(
          FindCommunityOutput(
            id: "",
            ownerId: faker.guid.guid(),
            members: [],
            description: faker.lorem.word(),
            title: faker.lorem.word(),
          ),
        ),
      );

      final result = await sut(input);

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l, (r) => null), isA<ValidationException>());
    });
  });
}
