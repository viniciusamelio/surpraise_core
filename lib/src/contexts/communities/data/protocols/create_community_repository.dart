import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import 'package:surpraise_core/src/contexts/communities/app/boundaries/create_community_boundaries.dart';

abstract class CreateCommunityRepository {
  Future<Either<Exception, CreateCommunityOutput>> createCommunity(
    CreateCommunityInput input,
  );
}
