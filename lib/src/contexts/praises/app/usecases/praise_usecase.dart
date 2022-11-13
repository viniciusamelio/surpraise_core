import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../boundaries/praise_boundaries.dart';

abstract class PraiseUsecase {
  Future<Either<Exception, PraiseOutput>> call(PraiseInput input);
}
