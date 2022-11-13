import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/contexts/users/app/boundaries/inactivate_user_boundaries.dart';
import 'package:surpraise_core/src/contexts/users/app/usecases/inactivate_user_usecase.dart';
import 'package:surpraise_core/src/contexts/users/data/protocols/inactivate_user_repository.dart';
import 'package:surpraise_core/src/contexts/users/domain/events/events.dart';
import 'package:surpraise_core/src/core/usecases/base_event_usecase.dart';
import 'package:surpraise_core/src/core/value_objects/id.dart';

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
