import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../boundaries/remove_members_boundaries.dart';

abstract class RemoveMembersUsecase {
  Future<Either<Exception, RemoveMembersOutput>> call(RemoveMembersInput input);
}
