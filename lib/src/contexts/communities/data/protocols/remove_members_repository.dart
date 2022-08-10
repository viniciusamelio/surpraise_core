import 'package:fpdart/fpdart.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/remove_members_boundaries.dart';

abstract class RemoveMembersRepository {
  Future<Either<Exception, RemoveMembersOutput>> removeMembers(
    RemoveMembersInput input,
  );
}
