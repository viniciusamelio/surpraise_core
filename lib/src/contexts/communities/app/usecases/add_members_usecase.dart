import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/events/event_bus.dart';
import '../boundaries/add_members_boundaries.dart';

abstract class AddMembersUsecase {
  AddMembersUsecase({
    required this.eventBus,
  });
  final EventBus eventBus;
  Future<Either<Exception, AddMembersOutput>> call(AddMembersInput input);
}
