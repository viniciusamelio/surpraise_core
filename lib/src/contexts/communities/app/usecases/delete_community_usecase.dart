// ignore_for_file: unused_field

import 'package:fpdart/fpdart.dart';

import '../../domain/services/delete_community_service.dart';
import '../boundaries/delete_community_boundaries.dart';

abstract class DeleteCommunityUsecase {
  DeleteCommunityUsecase(
    this._deleteCommunityService,
  );
  final IDeleteCommunityService _deleteCommunityService;
  Future<Either<Exception, DeleteCommunityOutput>> call(
    DeleteCommunityInput input,
  );
}
