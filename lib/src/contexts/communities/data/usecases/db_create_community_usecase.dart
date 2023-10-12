import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/protocols/services/id_service.dart';
import '../../../../core/value_objects/id.dart';
import '../../app/boundaries/create_community_boundaries.dart';
import '../../app/usecases/create_community_usecase.dart';
import '../../domain/entities/community.dart';
import '../../domain/entities/member.dart';
import '../../domain/value_objects/value_objects.dart';
import '../protocols/create_community_repository.dart';

class DbCreateCommunityUsecase implements CreateCommunityUsecase {
  const DbCreateCommunityUsecase({
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
      final community = Community(
        id: id,
        ownerId: Id(input.ownerId),
        description: Description(input.description),
        title: Title(input.title),
        members: [],
      );
      community.addMember(
        Member(
          id: Id(input.ownerId),
          communityId: id,
          role: Role.admin,
        ),
        input.planMemberLimit,
      );
      input.id = id.value;

      final createdCommunityOrException =
          await _createCommunityRepository.createCommunity(input);

      return createdCommunityOrException.fold(
        (l) => Left(l),
        (r) {
          return Right(r);
        },
      );
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
