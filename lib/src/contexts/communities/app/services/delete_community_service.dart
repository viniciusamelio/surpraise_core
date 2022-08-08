import 'package:surpraise_core/src/contexts/communities/domain/entities/community.dart';
import 'package:fpdart/fpdart.dart';
import 'package:surpraise_core/src/contexts/communities/domain/services/delete_community_service.dart';
import 'package:surpraise_core/src/core/exceptions/domain_exception.dart';

class DeleteCommunityService implements IDeleteCommunityService {
  @override
  Either<DomainException, void> call(Community community) {
    if (community.members.length > 1) {
      return Left(
        DomainException(
          "A community cannot be closed if there are more members besides the admin",
        ),
      );
    }
    return Right(null);
  }
}
