import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/boundaries.dart';
import 'package:surpraise_core/src/contexts/communities/app/usecases/invite_member_usecase.dart';
import 'package:surpraise_core/src/contexts/communities/data/protocols/protocols.dart';
import 'package:surpraise_core/src/contexts/communities/data/usecases/usecases.dart';
import 'package:surpraise_core/src/contexts/communities/domain/entities/entities.dart';
import 'package:surpraise_core/src/core/core.dart';
import 'package:test/test.dart';

class MockIdService extends Mock implements IdService {}

class MockInviteRepository extends Mock implements InviteRepository {}

class MockFindCommunityRepository extends Mock
    implements FindCommunityRepository {}

void main() {
  group("Invite member usecase: ", () {
    late final IdService idService;
    late final InviteRepository inviteRepository;
    late final FindCommunityRepository findCommunityRepository;
    late final InviteMemberUsecase sut;
    late final String inviterId;

    setUpAll(() async {
      idService = MockIdService();
      inviterId = faker.guid.guid();
      inviteRepository = MockInviteRepository();
      findCommunityRepository = MockFindCommunityRepository();
      sut = DbInviteMemberUsecase(
        inviteMemberRepository: inviteRepository,
        findCommunityRepository: findCommunityRepository,
        idService: idService,
      );

      registerFallbackValue(FindCommunityInput(id: ""));
      registerFallbackValue(
        InviteMemberInput(
          communityId: faker.guid.guid(),
          memberId: faker.guid.guid(),
          role: "moderator",
          inviterId: faker.guid.guid(),
        ),
      );
    });

    setUp(
      () async {
        when(
          () => findCommunityRepository.find(any()),
        ).thenAnswer(
          (invocation) async => Right(
            FindCommunityOutput(
              id: faker.guid.guid(),
              ownerId: faker.guid.guid(),
              description: faker.lorem.words(3).join(" "),
              title: faker.lorem.sentence(),
              members: [
                FindCommunityMemberDto(
                  id: inviterId,
                  role: Role.moderator.value,
                  communityId: faker.guid.guid(),
                )
              ],
            ),
          ),
        );

        when(() => idService.generate()).thenAnswer(
          (invocation) async => faker.guid.guid(),
        );

        when(
          () => inviteRepository.invite(
            any(),
          ),
        ).thenAnswer((invocation) async => Right(InviteMemberOutput()));
      },
    );

    test(
      "Sut should return left when member which will be added is already a member with given role",
      () async {
        final communityId = faker.guid.guid();
        final memberId = faker.guid.guid();
        when(
          () => findCommunityRepository.find(any()),
        ).thenAnswer(
          (invocation) async => Right(
            FindCommunityOutput(
              id: communityId,
              ownerId: faker.guid.guid(),
              description: faker.lorem.words(3).join(" "),
              title: faker.lorem.sentence(),
              members: [
                FindCommunityMemberDto(
                  id: memberId,
                  communityId: communityId,
                  role: "member",
                ),
                FindCommunityMemberDto(
                  id: inviterId,
                  communityId: communityId,
                  role: "moderator",
                ),
              ],
            ),
          ),
        );

        final response = await sut(
          InviteMemberInput(
            communityId: communityId,
            memberId: memberId,
            role: "member",
            inviterId: inviterId,
          ),
        );

        expect(response.isLeft(), isTrue);
        expect(
          response.fold((left) => left, (right) => null),
          isA<DomainException>(),
        );
      },
    );

    test(
      "Sut should return left when there is a pending invite for given member",
      () async {
        final communityId = faker.guid.guid();
        final memberId = faker.guid.guid();
        when(
          () => findCommunityRepository.find(any()),
        ).thenAnswer(
          (invocation) async => Right(
            FindCommunityOutput(
              id: communityId,
              ownerId: faker.guid.guid(),
              description: faker.lorem.words(3).join(" "),
              title: faker.lorem.sentence(),
              members: [
                FindCommunityMemberDto(
                  id: inviterId,
                  communityId: communityId,
                  role: "owner",
                ),
              ],
              invites: [
                FindCommunityInviteDto(
                  id: faker.guid.guid(),
                  memberId: memberId,
                  role: "moderator",
                ),
              ],
            ),
          ),
        );

        final response = await sut(
          InviteMemberInput(
            communityId: communityId,
            memberId: memberId,
            role: "member",
            inviterId: inviterId,
          ),
        );

        expect(response.isLeft(), isTrue);
        expect(
          response.fold((left) => left, (right) => null),
          isA<DomainException>(),
        );
      },
    );

    test(
      "Sut should return left when find community does so",
      () async {
        when(
          () => findCommunityRepository.find(any()),
        ).thenAnswer(
          (invocation) async => Left(
            Exception(),
          ),
        );

        final response = await sut(
          InviteMemberInput(
            communityId: faker.guid.guid(),
            memberId: faker.guid.guid(),
            role: faker.guid.guid(),
            inviterId: faker.guid.guid(),
          ),
        );

        expect(response.isLeft(), isTrue);
      },
    );

    test(
      "Sut should return left when invite repository does so",
      () async {
        final communityId = faker.guid.guid();
        final memberId = faker.guid.guid();
        when(() => inviteRepository.invite(any())).thenAnswer(
          (invocation) async => Left(Exception()),
        );

        final response = await sut(
          InviteMemberInput(
            communityId: communityId,
            memberId: memberId,
            role: "member",
            inviterId: inviterId,
          ),
        );

        expect(response.isLeft(), isTrue);
      },
    );

    test(
      "Sut should return right when there is no pending invite nor member with given role and id",
      () async {
        final communityId = faker.guid.guid();
        final memberId = faker.guid.guid();

        final response = await sut(
          InviteMemberInput(
            communityId: communityId,
            memberId: memberId,
            role: "member",
            inviterId: inviterId,
          ),
        );

        expect(response.isRight(), isTrue);
      },
    );

    test(
      "Sut should return left when inviter has the same role as invited",
      () async {
        final communityId = faker.guid.guid();
        final memberId = faker.guid.guid();

        final response = await sut(
          InviteMemberInput(
            communityId: communityId,
            memberId: memberId,
            role: "moderator",
            inviterId: inviterId,
          ),
        );

        expect(response.isLeft(), isTrue);
      },
    );

    test(
      "Sut should return left when invited has a greater role than inviter",
      () async {
        final communityId = faker.guid.guid();
        final memberId = faker.guid.guid();

        final response = await sut(
          InviteMemberInput(
            communityId: communityId,
            memberId: memberId,
            role: "owner",
            inviterId: inviterId,
          ),
        );

        expect(response.isLeft(), isTrue);
      },
    );

    test(
      "Sut should return left when re-inviting someone high a lower role",
      () async {
        final communityId = faker.guid.guid();
        final memberId = faker.guid.guid();
        when(
          () => findCommunityRepository.find(any()),
        ).thenAnswer(
          (invocation) async => Right(
            FindCommunityOutput(
              id: communityId,
              ownerId: inviterId,
              description: faker.lorem.words(3).join(" "),
              title: faker.lorem.sentence(),
              members: [
                FindCommunityMemberDto(
                  id: inviterId,
                  communityId: communityId,
                  role: "owner",
                ),
                FindCommunityMemberDto(
                  id: memberId,
                  communityId: communityId,
                  role: "moderator",
                ),
              ],
            ),
          ),
        );

        final response = await sut(
          InviteMemberInput(
            communityId: communityId,
            memberId: memberId,
            role: "member",
            inviterId: inviterId,
          ),
        );

        expect(response.isLeft(), isTrue);
      },
    );

    test(
      "Sut should return right when inviter is community owner and invited member is invited as owner too",
      () async {
        final communityId = faker.guid.guid();
        final memberId = faker.guid.guid();
        when(
          () => findCommunityRepository.find(any()),
        ).thenAnswer(
          (invocation) async => Right(
            FindCommunityOutput(
              id: communityId,
              ownerId: inviterId,
              description: faker.lorem.words(3).join(" "),
              title: faker.lorem.sentence(),
              members: [
                FindCommunityMemberDto(
                  id: inviterId,
                  communityId: communityId,
                  role: "owner",
                ),
              ],
            ),
          ),
        );

        final response = await sut(
          InviteMemberInput(
            communityId: communityId,
            memberId: memberId,
            role: "owner",
            inviterId: inviterId,
          ),
        );

        expect(response.isRight(), isTrue);
      },
    );

    test(
      "Sut should return left when inviter is not a community member",
      () async {
        final communityId = faker.guid.guid();
        final memberId = faker.guid.guid();

        final response = await sut(
          InviteMemberInput(
            communityId: communityId,
            memberId: memberId,
            role: "owner",
            inviterId: faker.guid.guid(),
          ),
        );

        expect(response.isLeft(), isTrue);
        expect(
          response.fold((left) => left, (right) => null),
          isA<DomainException>(),
        );
      },
    );

    test(
      "Sut should return left when trying to invite a member which role is greater than given role",
      () async {
        final communityId = faker.guid.guid();
        final memberId = faker.guid.guid();

        final response = await sut(
          InviteMemberInput(
            communityId: communityId,
            memberId: memberId,
            role: "owner",
            inviterId: inviterId,
          ),
        );

        expect(response.isLeft(), isTrue);
      },
    );
  });
}
