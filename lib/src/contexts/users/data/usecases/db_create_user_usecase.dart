import 'package:fpdart/fpdart.dart';

import 'package:surpraise_core/src/contexts/users/app/boundaries/create_user_boundaries.dart';
import 'package:surpraise_core/src/contexts/users/app/factories/user_factory.dart';
import 'package:surpraise_core/src/contexts/users/app/usecases/create_user_usecase.dart';
import 'package:surpraise_core/src/contexts/users/domain/events/events.dart';
import 'package:surpraise_core/src/core/protocols/services/id_service.dart';
import 'package:surpraise_core/src/core/usecases/base_event_usecase.dart';

import '../protocols/create_user_repository.dart';

class DbCreateUserUsecase extends EventEmitterUsecase
    implements CreateUserUsecase {
  DbCreateUserUsecase({
    required CreateUserRepository createUserRepository,
    required IdService idService,
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
          UserCreated(data: r),
        ),
      );
      return createdUserOrError;
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
