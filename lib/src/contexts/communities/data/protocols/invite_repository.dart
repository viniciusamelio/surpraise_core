import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../app/boundaries/boundaries.dart';

abstract class InviteRepository {
  Future<Either<Exception, InviteMemberOutput>> invite(InviteMemberInput input);
}
