import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../boundaries/edit_user_boundaries.dart';

abstract class EditUserUsecase {
  Future<Either<Exception, EditUserOutput>> call(EditUserInput input);
}
