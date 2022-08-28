import 'package:fpdart/fpdart.dart';
import 'package:surpraise_core/src/contexts/users/app/boundaries/edit_user_boundaries.dart';

abstract class EditUserRepository {
  Future<Either<Exception, EditUserOutput>> edit(EditUserInput input);
}
