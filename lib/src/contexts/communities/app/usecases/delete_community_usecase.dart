// ignore_for_file: unused_field

import 'package:fpdart/fpdart.dart';
import 'package:surpraise_core/src/core/events/event_bus.dart';

import '../../domain/services/delete_community_service.dart';
import '../boundaries/delete_community_boundaries.dart';

abstract class DeleteCommunityUsecase {
  DeleteCommunityUsecase(
    this._deleteCommunityService, {
    required this.eventBus,
  });
  final IDeleteCommunityService _deleteCommunityService;
  final EventBus eventBus;
  Future<Either<Exception, DeleteCommunityOutput>> call(
    DeleteCommunityInput input,
  );
}
