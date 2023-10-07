import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/exceptions/domain_exception.dart';
import '../../domain/entities/community.dart';
import '../../domain/services/delete_community_service.dart';

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
