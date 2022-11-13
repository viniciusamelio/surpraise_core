import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/delete_community_boundaries.dart';

abstract class DeleteCommunityRepository {
  Future<Either<Exception, DeleteCommunityOutput>> delete(
    DeleteCommunityInput input,
  );
}
