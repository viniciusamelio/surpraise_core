import 'package:surpraise_core/src/contexts/communities/app/boundaries/find_community_boundaries.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/remove_members_boundaries.dart';
import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/contexts/communities/app/usecases/remove_members_usecase.dart';
import 'package:surpraise_core/src/contexts/communities/data/protocols/protocols.dart';
import 'package:surpraise_core/src/contexts/communities/domain/entities/community.dart';
import 'package:surpraise_core/src/contexts/communities/domain/entities/member.dart';
import 'package:surpraise_core/src/contexts/communities/domain/events/events.dart';
import 'package:surpraise_core/src/contexts/communities/domain/value_objects/description.dart';
import 'package:surpraise_core/src/contexts/communities/domain/value_objects/title.dart';
import 'package:surpraise_core/src/core/exceptions/application_exception.dart';
import 'package:surpraise_core/src/core/usecases/base_event_usecase.dart';
import 'package:surpraise_core/src/core/value_objects/id.dart';

class DbRemoveMembersUsecase extends EventEmitterUsecase
    implements RemoveMembersUsecase {
  DbRemoveMembersUsecase({
    required RemoveMembersRepository removeMembersRepository,
    required FindCommunityRepository findCommunityRepository,
    required super.eventBus,
  })  : _removeMembersRepository = removeMembersRepository,
        _findCommunityRepository = findCommunityRepository;

  final RemoveMembersRepository _removeMembersRepository;
  final FindCommunityRepository _findCommunityRepository;

  @override
  Future<Either<Exception, RemoveMembersOutput>> call(
    RemoveMembersInput input,
  ) async {
    try {
      if (input.memberIds.isEmpty) {
        return Left(
          ApplicationException(
              message: "Can't remove an empty member list from a community"),
        );
      }
      final foundCommunityOrException = await _findCommunityRepository.find(
        FindCommunityInput(id: input.communityId),
      );
      return foundCommunityOrException.fold((l) => Left(l), (r) async {
        try {
          final List<Id> memberIds = [];
          memberIds.addAll(
            input.memberIds
                .map<Id>(
                  (e) => Id(
                    e,
                  ),
                )
                .toList(),
          );
          final Community community = Community(
            id: Id(r.id),
            ownerId: Id(r.ownerId),
            description: Description(r.description),
            title: Title(r.title),
            members: r.members
                .map<Member>(
                  (e) => Member(
                    id: Id(e.id),
                    communityId: Id(e.communityId),
                    role: Role.fromString(e.role),
                  ),
                )
                .toList(),
          );
          for (final id in memberIds) {
            community.removeMember(id);
          }

          final removedMembersFeedbackOrException =
              await _removeMembersRepository.removeMembers(
            input,
          );
          _notify(input);
          return removedMembersFeedbackOrException;
        } on Exception catch (e) {
          return Left(e);
        }
      });
    } on Exception catch (e) {
      return Left(e);
    }
  }

  void _notify(
    RemoveMembersInput input,
  ) {
    for (var id in input.memberIds) {
      notify(
        MemberRemoved(communityId: input.communityId, memberId: id),
      );
    }
  }
}
