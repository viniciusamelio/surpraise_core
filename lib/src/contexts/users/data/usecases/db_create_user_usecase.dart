import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/protocols/services/id_service.dart';
import '../../../../core/usecases/base_event_usecase.dart';
import '../../app/boundaries/create_user_boundaries.dart';
import '../../app/factories/user_factory.dart';
import '../../app/usecases/create_user_usecase.dart';
import '../../domain/events/events.dart';
import '../protocols/create_user_repository.dart';

class DbCreateUserUsecase extends EventEmitterUsecase
    implements CreateUserUsecase {
  DbCreateUserUsecase({
    required CreateUserRepository createUserRepository,
    required IdService idService,
    required super.eventBus,
  })  : _createUserRepository = createUserRepository,
        _idService = idService;

  final CreateUserRepository _createUserRepository;
  final IdService _idService;

  @override
  Future<Either<Exception, CreateUserOutput>> call(
    CreateUserInput input,
  ) async {
    try {
      final id = await _idService.generate();
      UserFactory.fromCreateInputDto(input, id);
      input.id = id;
      final createdUserOrError = await _createUserRepository.create(input);
      createdUserOrError.fold(
        (l) => null,
        (r) => notify(
          UserCreated(
            id: r.id,
            tag: r.tag,
            email: r.email,
          ),
        ),
      );
      return createdUserOrError;
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
