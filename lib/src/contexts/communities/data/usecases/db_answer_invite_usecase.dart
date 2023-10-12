import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/value_objects/id.dart';
import '../../app/boundaries/boundaries.dart';
import '../../app/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../protocols/protocols.dart';

class DbAnswerInviteUsecase implements AnswerInviteUsecase {
  const DbAnswerInviteUsecase({
    required AnswerInviteRepository answerInviteRepository,
  }) : _answerInviteRepository = answerInviteRepository;
  final AnswerInviteRepository _answerInviteRepository;

  @override
  Future<Either<Exception, AnswerInviteOutput>> call(
    AnswerInviteInput input,
  ) async {
    try {
      final inviteOrError = await _answerInviteRepository.findInvite(input.id);
      if (inviteOrError.isLeft()) {
        return Left(inviteOrError.fold((l) => l, (r) => null)!);
      }

      final Invite invite = inviteOrError.fold(
        (left) => null,
        (right) => Invite(
          id: Id(right.id),
          role: Role.fromString(right.role),
          status: InviteStatus.fromString(right.status),
        ),
      )!;

      input.accepted ? invite.accept() : invite.refuse();

      final answerOrError = await _answerInviteRepository.answerInvite(input);
      if (answerOrError.isLeft()) {
        return Left(answerOrError.fold((l) => l, (r) => null)!);
      }
      return Right(AnswerInviteOutput());
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
