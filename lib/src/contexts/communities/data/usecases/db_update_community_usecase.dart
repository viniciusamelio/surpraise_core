import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/value_objects/id.dart';
import '../../app/boundaries/update_community_boundaries.dart';
import '../../app/usecases/usecases.dart';
import '../../domain/entities/entities.dart';
import '../../domain/value_objects/value_objects.dart';
import '../protocols/protocols.dart';

class DbUpdateCommunityUsecase implements UpdateCommunityUsecase {
  DbUpdateCommunityUsecase({
    required UpdateCommunityRepository updateCommunityRepository,
  }) : _repository = updateCommunityRepository;

  final UpdateCommunityRepository _repository;

  @override
  Future<Either<Exception, UpdateCommunityOutput>> call(
    UpdateCommunityInput input,
  ) async {
    try {
      Community(
        id: Id(input.id!),
        ownerId: Id(input.ownerId),
        description: Description(input.description),
        title: Title(input.title),
        members: [],
      );

      final updatedCommunityOrError = await _repository.update(input);
      if (updatedCommunityOrError.isLeft()) {
        return Left(updatedCommunityOrError.fold((l) => l, (r) => null)!);
      }
      return Right(
        UpdateCommunityOutput(
          id: input.id!,
          description: input.description,
          title: input.title,
          imageUrl: input.imageUrl,
        ),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
