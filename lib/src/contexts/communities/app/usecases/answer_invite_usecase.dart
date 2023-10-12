import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../communities.dart';

abstract class AnswerInviteUsecase {
  Future<Either<Exception, AnswerInviteOutput>> call(
    AnswerInviteInput input,
  );
}
