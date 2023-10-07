import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/events/event_bus.dart';
import '../boundaries/create_community_boundaries.dart';

abstract class CreateCommunityUsecase {
  CreateCommunityUsecase({
    required this.eventBus,
  });
  Future<Either<Exception, CreateCommunityOutput>> call(
    CreateCommunityInput input,
  );
  final EventBus eventBus;
}
