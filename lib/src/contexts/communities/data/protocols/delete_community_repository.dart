import 'package:fpdart/fpdart.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/delete_community_boundaries.dart';

abstract class DeleteCommunityRepository {
  Future<Either<Exception, DeleteCommunityOutput>> delete(
    DeleteCommunityInput input,
  );
}
