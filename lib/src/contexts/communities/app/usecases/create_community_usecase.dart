import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../boundaries/create_community_boundaries.dart';

abstract class CreateCommunityUsecase {
  const CreateCommunityUsecase();
  Future<Either<Exception, CreateCommunityOutput>> call(
    CreateCommunityInput input,
  );
}
