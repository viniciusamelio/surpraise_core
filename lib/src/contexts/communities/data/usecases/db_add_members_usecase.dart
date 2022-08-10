import 'package:surpraise_core/src/contexts/communities/app/boundaries/add_members_boundaries.dart';
import 'package:fpdart/fpdart.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/find_community_boundaries.dart';
import 'package:surpraise_core/src/contexts/communities/app/usecases/add_members_usecase.dart';
import 'package:surpraise_core/src/contexts/communities/data/protocols/protocols.dart';
import 'package:surpraise_core/src/contexts/communities/domain/entities/community.dart';
import 'package:surpraise_core/src/contexts/communities/domain/entities/member.dart';
import 'package:surpraise_core/src/contexts/communities/domain/value_objects/description.dart';
import 'package:surpraise_core/src/contexts/communities/domain/value_objects/title.dart';
import 'package:surpraise_core/src/core/exceptions/application_exception.dart';
import 'package:surpraise_core/src/core/exceptions/domain_exception.dart';
import 'package:surpraise_core/src/core/value_objects/id.dart';

import '../protocols/add_members_repository.dart';

class DbAddMembersUsecase implements AddMembersUsecase {
  DbAddMembersUsecase({
    required AddMembersRepository addMembersRepository,
    required FindCommunityRepository findCommunityRepository,
  })  : _addMembersRepository = addMembersRepository,
        _findCommunityRepository = findCommunityRepository;

  final AddMembersRepository _addMembersRepository;
  final FindCommunityRepository _findCommunityRepository;

  @override
  Future<Either<Exception, AddMembersOutput>> call(
    AddMembersInput input,
  ) async {
    try {
      final foundCommunityOrError = await _findCommunityRepository.find(
        FindCommunityInput(
          id: input.idCommunity,
        ),
      );

      return foundCommunityOrError.fold((l) => Left(l), (r) async {
        late Community community;

        try {
          community = Community(
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
        } on Exception catch (e) {
          return Left(e);
        }

        if (input.members.isEmpty) {
          return Left(
            ApplicationException(
              message: "You can't add zero members to a community",
            ),
          );
        }

        for (final memberDto in input.members) {
          try {
            community.addMember(
              Member(
                id: Id(memberDto.idMember),
                communityId: Id(input.idCommunity),
                role: Role.fromString(memberDto.role),
              ),
              50,
            );
          } on DomainException catch (e) {
            return Left(e);
          }
        }
        final addedMembersFeedbackOrError =
            await _addMembersRepository.addMembers(input);
        return addedMembersFeedbackOrError;
      });
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
