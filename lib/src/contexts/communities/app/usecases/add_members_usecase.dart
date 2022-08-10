import 'package:fpdart/fpdart.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/add_members_boundaries.dart';

abstract class AddMembersUsecase {
  Future<Either<Exception, AddMembersOutput>> call(AddMembersInput input);
}
