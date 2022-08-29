import 'package:fpdart/fpdart.dart';
import 'package:surpraise_core/src/contexts/communities/domain/entities/community.dart';
import 'package:surpraise_core/src/contexts/communities/domain/entities/member.dart';
import 'package:surpraise_core/src/contexts/communities/domain/events/events.dart';
import 'package:surpraise_core/src/contexts/communities/domain/services/delete_community_service.dart';
import 'package:surpraise_core/src/contexts/communities/domain/value_objects/description.dart';
import 'package:surpraise_core/src/contexts/communities/domain/value_objects/title.dart';
import 'package:surpraise_core/src/core/events/event_bus.dart';
import 'package:surpraise_core/src/core/value_objects/id.dart';

import '../../app/boundaries/delete_community_boundaries.dart';
import '../../app/boundaries/find_community_boundaries.dart';
import '../../app/usecases/delete_community_usecase.dart';
import '../protocols/protocols.dart';

class DbDeleteCommunityUsecase implements DeleteCommunityUsecase {
  DbDeleteCommunityUsecase({
    required DeleteCommunityRepository deleteCommunityRepository,
    required FindCommunityRepository findCommunityRepository,
    required IDeleteCommunityService deleteCommunityService,
    required this.eventBus,
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
          _notify(input);
          return feedbackOrError;
        });
      });
    } on Exception catch (e) {
      return Left(e);
    }
  }

  void _notify(DeleteCommunityInput input) {
    eventBus.addEvent(
      CommunityDeleted(
        communityId: input.id,
      ),
    );
  }

  @override
  final EventBus eventBus;
}
