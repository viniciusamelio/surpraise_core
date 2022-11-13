import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/create_community_boundaries.dart';
import 'package:surpraise_core/src/core/events/event_bus.dart';

abstract class CreateCommunityUsecase {
  CreateCommunityUsecase({
    required this.eventBus,
  });
  Future<Either<Exception, CreateCommunityOutput>> call(
    CreateCommunityInput input,
  );
  final EventBus eventBus;
}
