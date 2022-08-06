import 'package:fpdart/fpdart.dart';

import '../boundaries/delete_community_boundaries.dart';

abstract class DeleteCommunityUsecase {
  Future<Either<Exception, DeleteCommunityOutput>> call(
    DeleteCommunityInput input,
  );
}
