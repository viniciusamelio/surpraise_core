import 'package:fpdart/fpdart.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/add_members_boundaries.dart';

abstract class AddMembersRepository {
  Future<Either<Exception, AddMembersOutput>> addMembers(AddMembersInput input);
}
