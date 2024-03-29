import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/usecases/base_event_usecase.dart';
import '../../../../core/value_objects/id.dart';
import '../../app/boundaries/delete_community_boundaries.dart';
import '../../app/boundaries/find_community_boundaries.dart';
import '../../app/usecases/delete_community_usecase.dart';
import '../../domain/entities/community.dart';
import '../../domain/entities/member.dart';
import '../../domain/events/events.dart';
import '../../domain/services/delete_community_service.dart';
import '../../domain/value_objects/description.dart';
import '../../domain/value_objects/title.dart';
import '../protocols/protocols.dart';

class DbDeleteCommunityUsecase extends EventEmitterUsecase
    implements DeleteCommunityUsecase {
  DbDeleteCommunityUsecase({
    required DeleteCommunityRepository deleteCommunityRepository,
    required FindCommunityRepository findCommunityRepository,
    required IDeleteCommunityService deleteCommunityService,
    required super.eventBus,
  })  : _deleteCommunityRepository = deleteCommunityRepository,
        _findCommunityRepository = findCommunityRepository,
        _deleteCommunityService = deleteCommunityService;

  final DeleteCommunityRepository _deleteCommunityRepository;
  final FindCommunityRepository _findCommunityRepository;
  final IDeleteCommunityService _deleteCommunityService;

  @override
  Future<Either<Exception, DeleteCommunityOutput>> call(
    DeleteCommunityInput input,
  ) async {
    try {
      final foundCommunityOrError = await _findCommunityRepository.find(
        FindCommunityInput(
          id: input.id,
        ),
      );
      return foundCommunityOrError.fold((l) => Left(l), (foundCommunity) async {
        final serviceResponse = _deleteCommunityService(
          Community(
            id: Id(foundCommunity.id),
            ownerId: Id(foundCommunity.ownerId),
            description: Description(foundCommunity.description),
            title: Title(foundCommunity.title),
            members: foundCommunity.members
                .map<Member>(
                  (e) => Member(
                    id: Id(e.id),
                    communityId: Id(e.communityId),
                    role: Role.fromString(e.role),
                  ),
                )
                .toList(),
          ),
        );
        return serviceResponse.fold((l) => Left(l), (r) async {
          final feedbackOrError =
              await _deleteCommunityRepository.delete(input);
          notify(
            CommunityDeleted(
              communityId: input.id,
            ),
          );
          return feedbackOrError;
        });
      });
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
