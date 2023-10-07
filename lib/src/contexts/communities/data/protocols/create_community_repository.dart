import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../app/boundaries/create_community_boundaries.dart';

abstract class CreateCommunityRepository {
  Future<Either<Exception, CreateCommunityOutput>> createCommunity(
    CreateCommunityInput input,
  );
}
