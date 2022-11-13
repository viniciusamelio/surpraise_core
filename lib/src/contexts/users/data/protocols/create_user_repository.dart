import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/contexts/users/app/boundaries/create_user_boundaries.dart';

abstract class CreateUserRepository {
  Future<Either<Exception, CreateUserOutput>> create(CreateUserInput input);
}
