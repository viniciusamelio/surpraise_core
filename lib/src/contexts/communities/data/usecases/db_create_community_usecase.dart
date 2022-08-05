import 'package:fpdart/fpdart.dart';

import 'package:surpraise_core/src/contexts/communities/app/boundaries/create_community_boundaries.dart';
import 'package:surpraise_core/src/contexts/communities/app/usecases/create_community_usecase.dart';
import 'package:surpraise_core/src/contexts/communities/data/protocols/create_community_repository.dart';
import 'package:surpraise_core/src/contexts/communities/domain/entities/community.dart';
import 'package:surpraise_core/src/contexts/communities/domain/value_objects/value_objects.dart';
import 'package:surpraise_core/src/core/protocols/services/id_service.dart';
import 'package:surpraise_core/src/core/value_objects/id.dart';

class DbCreateCommunityUsecase implements CreateCommunityUsecase {
  DbCreateCommunityUsecase({
    required CreateCommunityRepository createCommunityRepository,
    required IdService idService,
  })  : _idService = idService,
        _createCommunityRepository = createCommunityRepository;

  final CreateCommunityRepository _createCommunityRepository;
  final IdService _idService;

  @override
  Future<Either<Exception, CreateCommunityOutput>> call(
    CreateCommunityInput input,
  ) async {
    try {
      final id = Id(
        await _idService.generate(),
      );
      Community(
        id: id,
        ownerId: Id(input.ownerId),
        description: Description(input.description),
        title: Title(input.title),
        members: [],
      );
      input.id = id.value;

      final createdCommunityOrException =
          await _createCommunityRepository.createCommunity(input);

      return createdCommunityOrException.fold(
        (l) => Left(l),
        (r) => Right(r),
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
