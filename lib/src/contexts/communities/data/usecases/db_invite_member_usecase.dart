import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/core.dart';
import '../../../../core/value_objects/id.dart';
import '../../app/boundaries/boundaries.dart';
import '../../app/usecases/invite_member_usecase.dart';
import '../../domain/aggregates/invite.dart';
import '../../domain/entities/entities.dart';
import '../../domain/value_objects/value_objects.dart';
import '../protocols/protocols.dart';

class DbInviteMemberUsecase implements InviteMemberUsecase {
  DbInviteMemberUsecase({
    required InviteRepository inviteMemberRepository,
    required FindCommunityRepository findCommunityRepository,
    required IdService idService,
  })  : _inviteRepository = inviteMemberRepository,
        _idService = idService,
        _findCommunityRepository = findCommunityRepository;

  final InviteRepository _inviteRepository;
  final FindCommunityRepository _findCommunityRepository;
  final IdService _idService;

  @override
  Future<Either<Exception, InviteMemberOutput>> call(
    InviteMemberInput input,
  ) async {
    try {
      final communityOrError = await _findCommunityRepository.find(
        FindCommunityInput(
          id: input.communityId,
          withInvites: true,
        ),
      );
      if (communityOrError.isLeft()) {
        return Left(communityOrError.fold((l) => l, (r) => null)!);
      }

      final communityDto = communityOrError.fold(
        (l) => null,
        (r) => r,
      )!;
      final community = Community(
        id: Id(communityDto.id),
        ownerId: Id(communityDto.ownerId),
        description: Description(communityDto.description),
        title: Title(communityDto.title),
        invitedMembers: communityDto.invites
            .map(
              (e) => Member(
                id: Id(e.memberId),
                communityId: Id(input.communityId),
                role: Role.fromString(e.role),
              ),
            )
            .toList(),
        members: communityDto.members
            .map<Member>((e) => Member(
                  id: Id(e.id),
                  communityId: Id(e.communityId),
                  role: Role.fromString(e.role),
                ))
            .toList(),
      );

      final invite = Invite(
        id: Id(await _idService.generate()),
        role: Role.fromString(input.role),
        status: InviteStatus.pending,
      );

      final inviteAggregate = InviteAggregate(
        community: community,
        invite: invite,
      );

      inviteAggregate.invite(
        member: Member(
          id: Id(input.memberId),
          communityId: Id(input.communityId),
          role: Role.fromString(input.role),
        ),
      );

      final inviteOrError = await _inviteRepository.invite(input);
      return inviteOrError;
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
