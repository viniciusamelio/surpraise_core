import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/find_community_boundaries.dart';

abstract class FindCommunityRepository {
  Future<Either<Exception, FindCommunityOutput>> find(
    FindCommunityInput input,
  );
}
