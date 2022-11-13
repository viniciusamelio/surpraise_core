import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/contexts/users/app/boundaries/edit_user_boundaries.dart';

abstract class EditUserUsecase {
  Future<Either<Exception, EditUserOutput>> call(EditUserInput input);
}
