import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../app/boundaries/edit_user_boundaries.dart';

abstract class EditUserRepository {
  Future<Either<Exception, EditUserOutput>> edit(EditUserInput input);
}
