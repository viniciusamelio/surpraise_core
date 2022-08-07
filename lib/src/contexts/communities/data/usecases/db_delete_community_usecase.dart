import 'package:fpdart/fpdart.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../app/boundaries/delete_community_boundaries.dart';
import '../../app/boundaries/find_community_boundaries.dart';
import '../../app/usecases/delete_community_usecase.dart';
import '../protocols/protocols.dart';

class DbDeleteCommunityUsecase implements DeleteCommunityUsecase {
  DbDeleteCommunityUsecase({
    required DeleteCommunityRepository deleteCommunityRepository,
    required FindCommunityRepository findCommunityRepository,
  })  : _deleteCommunityRepository = deleteCommunityRepository,
        _findCommunityRepository = findCommunityRepository;

  final DeleteCommunityRepository _deleteCommunityRepository;
  final FindCommunityRepository _findCommunityRepository;

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
        if (foundCommunity.members.length > 1) {
          return Left(
            DomainException(
              "A community cannot be closed if there are more members besides the admin",
            ),
          );
        }
        final feedbackOrError = await _deleteCommunityRepository.delete(input);
        return feedbackOrError;
      });
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
