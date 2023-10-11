import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../../surpraise_core.dart';

abstract class LeaveCommunityRepository {
  Future<Either<Exception, LeaveCommunityOutput>> leave(
    LeaveCommunityInput input,
  );
  Future<Either<Exception, CommunityDetailsOutput>> getCommunityDetails(
      String communityId);
}
