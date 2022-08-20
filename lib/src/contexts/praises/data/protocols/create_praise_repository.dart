import 'package:fpdart/fpdart.dart';
import 'package:surpraise_core/src/contexts/praises/app/boundaries/praise_boundaries.dart';

abstract class CreatePraiseRepository {
  Future<Either<Exception, PraiseOutput>> create(PraiseInput input);
}
