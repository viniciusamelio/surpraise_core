import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../app/boundaries/edit_user_boundaries.dart';
import '../../app/factories/user_factory.dart';
import '../../app/usecases/edit_user_usecase.dart';
import '../protocols/edit_user_repository.dart';

class DbEditUserUsecase implements EditUserUsecase {
  DbEditUserUsecase({
    required EditUserRepository editUserRepository,
  }) : _editUserRepository = editUserRepository;
  final EditUserRepository _editUserRepository;

  @override
  Future<Either<Exception, EditUserOutput>> call(EditUserInput input) async {
    try {
      UserFactory.fromEditInputDto(input);
      final editedUserOrError = await _editUserRepository.edit(input);
      return editedUserOrError;
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
