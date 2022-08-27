import 'package:fpdart/fpdart.dart';
import 'package:surpraise_core/src/contexts/users/app/boundaries/create_user_boundaries.dart';

abstract class CreateUserRepository {
  Future<Either<Exception, CreateUserOutput>> create(CreateUserInput input);
}
