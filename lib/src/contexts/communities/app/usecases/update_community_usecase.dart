import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../boundaries/update_community_boundaries.dart';

abstract class UpdateCommunityUsecase {
  Future<Either<Exception, UpdateCommunityOutput>> call(
    UpdateCommunityInput input,
  );
}
