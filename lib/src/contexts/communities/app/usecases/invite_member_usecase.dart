import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../boundaries/boundaries.dart';

abstract class InviteMemberUsecase {
  Future<Either<Exception, InviteMemberOutput>> call(InviteMemberInput input);
}
