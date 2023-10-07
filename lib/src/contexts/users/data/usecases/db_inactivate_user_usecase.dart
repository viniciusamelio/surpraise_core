import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/usecases/base_event_usecase.dart';
import '../../../../core/value_objects/id.dart';
import '../../app/boundaries/inactivate_user_boundaries.dart';
import '../../app/usecases/inactivate_user_usecase.dart';
import '../../domain/events/events.dart';
import '../protocols/inactivate_user_repository.dart';

class DbInactivateUserUsecase extends EventEmitterUsecase
    implements InactivateUserUsecase {
  DbInactivateUserUsecase({
    required InactivateUserRepository inactivateUserRepository,
    required super.eventBus,
  }) : _inactivateUserRepository = inactivateUserRepository;
  final InactivateUserRepository _inactivateUserRepository;

  @override
  Future<Either<Exception, InactivateUserOutput>> call(
    InactivateUserInput input,
  ) async {
    try {
      Id(input.id);
      final inactivateUserMessageOrError =
          await _inactivateUserRepository.inactivate(
        input,
      );
      notify(
        UserInactivated(input.id),
      );
      return inactivateUserMessageOrError;
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
