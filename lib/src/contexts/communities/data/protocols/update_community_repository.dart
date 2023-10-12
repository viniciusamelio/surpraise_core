import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../app/boundaries/update_community_boundaries.dart';

abstract class UpdateCommunityRepository {
  Future<Either<Exception, UpdateCommunityOutput>> update(
    UpdateCommunityInput input,
  );
}
