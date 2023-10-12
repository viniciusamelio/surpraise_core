import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../../surpraise_core.dart';

abstract class AnswerInviteRepository {
  Future<Either<Exception, AnswerInviteOutput>> answerInvite(
    AnswerInviteInput input,
  );

  Future<Either<Exception, FindInviteOutput>> findInvite(String id);
}
