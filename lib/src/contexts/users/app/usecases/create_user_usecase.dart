import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../boundaries/create_user_boundaries.dart';

abstract class CreateUserUsecase {
  Future<Either<Exception, CreateUserOutput>> call(
    CreateUserInput input,
  );
}
