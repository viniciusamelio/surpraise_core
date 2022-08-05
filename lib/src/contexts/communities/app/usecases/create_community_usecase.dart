import 'package:fpdart/fpdart.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/create_community_boundaries.dart';

abstract class CreateCommunityUsecase {
  Future<Either<Exception, CreateCommunityOutput>> call(
    CreateCommunityInput input,
  );
}
