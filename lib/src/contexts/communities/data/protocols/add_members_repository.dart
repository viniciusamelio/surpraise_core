import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../app/boundaries/add_members_boundaries.dart';

abstract class AddMembersRepository {
  Future<Either<Exception, AddMembersOutput>> addMembers(AddMembersInput input);
}
