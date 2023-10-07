import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../app/boundaries/find_community_boundaries.dart';

abstract class FindCommunityRepository {
  Future<Either<Exception, FindCommunityOutput>> find(
    FindCommunityInput input,
  );
}
