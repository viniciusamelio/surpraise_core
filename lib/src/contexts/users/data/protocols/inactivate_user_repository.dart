import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import '../../app/boundaries/inactivate_user_boundaries.dart';

abstract class InactivateUserRepository {
  Future<Either<Exception, InactivateUserOutput>> inactivate(
    InactivateUserInput input,
  );
}
