import 'package:fpdart/fpdart.dart';

import '../boundaries/praise_boundaries.dart';

abstract class PraiseUsecase {
  Future<Either<Exception, PraiseOutput>> call(PraiseInput input);
}
