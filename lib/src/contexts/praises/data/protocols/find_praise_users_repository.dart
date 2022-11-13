import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/contexts/praises/data/dtos/find_praise_users_dto.dart';

abstract class FindPraiseUsersRepository {
  Future<Either<Exception, FindPraiseUsersDto>> find({
    required String praiserId,
    required String praisedId,
  });
}
