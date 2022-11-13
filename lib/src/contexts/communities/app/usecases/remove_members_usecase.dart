import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import 'package:surpraise_core/src/core/events/event_bus.dart';

import '../boundaries/remove_members_boundaries.dart';

abstract class RemoveMembersUsecase {
  RemoveMembersUsecase({
    required this.eventBus,
  });
  final EventBus eventBus;
  Future<Either<Exception, RemoveMembersOutput>> call(RemoveMembersInput input);
}
