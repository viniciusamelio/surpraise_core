import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../communities.dart';

abstract class LeaveCommunityUsecase {
  Future<Either<Exception, LeaveCommunityOutput>> call(
      LeaveCommunityInput input);
}
