import '../boundaries/remove_members_boundaries.dart';

import 'package:fpdart/fpdart.dart';

abstract class RemoveMembersUsecase {
  Future<Either<Exception, RemoveMembersOutput>> call(RemoveMembersInput input);
}
