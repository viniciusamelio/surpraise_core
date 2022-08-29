import 'package:fpdart/fpdart.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/add_members_boundaries.dart';
import 'package:surpraise_core/src/core/events/event_bus.dart';

abstract class AddMembersUsecase {
  AddMembersUsecase({
    required this.eventBus,
  });
  final EventBus eventBus;
  Future<Either<Exception, AddMembersOutput>> call(AddMembersInput input);
}
