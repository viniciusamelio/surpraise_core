import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/core.dart';
import '../../../../core/value_objects/id.dart';
import '../../app/boundaries/leave_community_boundaries.dart';

import '../../app/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../protocols/protocols.dart';

class DbLeaveCommunityUsecase implements LeaveCommunityUsecase {
  const DbLeaveCommunityUsecase({
    required this.leaveCommunityRepository,
  });
  final LeaveCommunityRepository leaveCommunityRepository;

  @override
  Future<Either<Exception, LeaveCommunityOutput>> call(
    LeaveCommunityInput input,
  ) async {
    try {
      final member = Member(
        id: Id(input.memberId),
        communityId: Id(input.communityId),
        role: Role.fromString(input.memberRole),
      );

      final membersCountOrError =
          await leaveCommunityRepository.getCommunityDetails(
        input.communityId,
      );

      if (membersCountOrError.isLeft()) {
        return Left(
          Exception(
            "Something went wrong getting community members count",
          ),
        );
      }

      member.leaveCommunity(
        communityMembersCount: membersCountOrError
            .fold((left) => null, (right) => right)!
            .membersCount,
        ownerId:
            membersCountOrError.fold((left) => null, (right) => right)!.ownerId,
      );

      return await leaveCommunityRepository.leave(input);
    } on DomainException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception("It was not possibile to leave the community"));
    }
  }
}
