import 'package:surpraise_core/src/contexts/users/app/boundaries/edit_user_boundaries.dart';
import 'package:fpdart/fpdart.dart';
import 'package:surpraise_core/src/contexts/users/app/factories/user_factory.dart';
import 'package:surpraise_core/src/contexts/users/app/usecases/edit_user_usecase.dart';
import 'package:surpraise_core/src/contexts/users/data/protocols/edit_user_repository.dart';

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
