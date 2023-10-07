import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../app/boundaries/create_user_boundaries.dart';

abstract class CreateUserRepository {
  Future<Either<Exception, CreateUserOutput>> create(CreateUserInput input);
}
