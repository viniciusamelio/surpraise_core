import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/exceptions/application_exception.dart';
import '../../../../core/value_objects/id.dart';
import '../../app/boundaries/find_community_boundaries.dart';
import '../../app/boundaries/remove_members_boundaries.dart';
import '../../app/usecases/remove_members_usecase.dart';
import '../../domain/entities/community.dart';
import '../../domain/entities/member.dart';
import '../../domain/value_objects/description.dart';
import '../../domain/value_objects/title.dart';
import '../protocols/protocols.dart';

class DbRemoveMembersUsecase implements RemoveMembersUsecase {
  DbRemoveMembersUsecase({
    required RemoveMembersRepository removeMembersRepository,
    required FindCommunityRepository findCommunityRepository,
  })  : _removeMembersRepository = removeMembersRepository,
        _findCommunityRepository = findCommunityRepository;

  final RemoveMembersRepository _removeMembersRepository;
  final FindCommunityRepository _findCommunityRepository;

  @override
  Future<Either<Exception, RemoveMembersOutput>> call(
    RemoveMembersInput input,
  ) async {
    try {
      if (input.members.isEmpty) {
        return Left(
          ApplicationException(
            message: "Can't remove an empty member list from a community",
          ),
        );
      }
      final foundCommunityOrException = await _findCommunityRepository.find(
        FindCommunityInput(id: input.communityId),
      );
      return foundCommunityOrException.fold((l) => Left(l), (r) async {
        try {
          final List<Member> members = [];
          members.addAll(
            input.members
                .map<Member>(
                  (e) => Member(
                    id: Id(
                      e.id,
                    ),
                    communityId: Id(input.communityId),
                    role: Role.fromString(e.role),
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
          final mod = Member(
            id: Id(input.moderator.id),
            communityId: Id(input.communityId),
            role: Role.fromString(input.moderator.role),
          );

          for (final member in members) {
            community.removeMember(
              moderator: mod,
              member: Member(
                id: member.id,
                communityId: member.communityId,
                role: member.role,
              ),
            );
          }

          final removedMembersFeedbackOrException =
              await _removeMembersRepository.removeMembers(
            input,
          );
          return removedMembersFeedbackOrException;
        } on Exception catch (e) {
          return Left(e);
        }
      });
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
