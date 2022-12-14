import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/contexts/users/app/boundaries/inactivate_user_boundaries.dart';

abstract class InactivateUserUsecase {
  Future<Either<Exception, InactivateUserOutput>> call(
    InactivateUserInput input,
  );
}
