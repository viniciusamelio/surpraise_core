import 'package:surpraise_core/src/contexts/praises/app/boundaries/praise_boundaries.dart';
import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/contexts/praises/app/usecases/praise_usecase.dart';
import 'package:surpraise_core/src/contexts/praises/domain/entities/user.dart';
import 'package:surpraise_core/src/contexts/praises/domain/events/praise_sent.dart';
import 'package:surpraise_core/src/contexts/praises/domain/value_objects/message.dart';
import 'package:surpraise_core/src/contexts/praises/domain/value_objects/tag.dart';
import 'package:surpraise_core/src/contexts/praises/domain/value_objects/topic.dart';
import 'package:surpraise_core/src/core/exceptions/application_exception.dart';
import 'package:surpraise_core/src/core/protocols/services/id_service.dart';
import 'package:surpraise_core/src/core/usecases/base_event_usecase.dart';
import 'package:surpraise_core/src/core/value_objects/id.dart';

import '../mappers/praise_mappers.dart';
import '../protocols/protocols.dart';

class DbPraiseUsecase extends EventEmitterUsecase<PraiseSent>
    implements PraiseUsecase {
  DbPraiseUsecase({
    required CreatePraiseRepository createPraiseRepository,
    required IdService idService,
    required FindPraiseUsersRepository findPraiseUsersRepository,
  })  : _createPraiseRepository = createPraiseRepository,
        _idService = idService,
        _findPraiseUsersRepository = findPraiseUsersRepository;

  final CreatePraiseRepository _createPraiseRepository;
  final FindPraiseUsersRepository _findPraiseUsersRepository;
  final IdService _idService;

  @override
  Future<Either<Exception, PraiseOutput>> call(PraiseInput input) async {
    try {
      final usersOrError = await _findPraiseUsersRepository.find(
        praiserId: input.praiserId,
        praisedId: input.praisedId,
      );
      return usersOrError.fold((l) => Left(l), (usersDto) async {
        try {
          input.id = await _idService.generate();
          if (usersDto.praisedDto.tag == usersDto.praiserDto.tag) {
            return Left(
              ApplicationException(message: "You cannot praise yourself"),
            );
          }
          final praiser = User(
            tag: Tag(usersDto.praiserDto.tag),
            communities: mapCommunityIdsFromStringList(
              usersDto.praiserDto.communities,
            ),
          );
          final praised = User(
            tag: Tag(usersDto.praisedDto.tag),
            communities: mapCommunityIdsFromStringList(
              usersDto.praisedDto.communities,
            ),
          );
          praiser.praise(
            praised: praised,
            message: Message(input.message),
            topic: Topic(input.topic),
            communityId: Id(input.commmunityId),
            id: Id(
              await _idService.generate(),
            ),
          );
          final praiseOrError = await _createPraiseRepository.create(input);
          notify(
            PraiseSent(
              praisedId: input.praisedId,
              id: input.id,
              commmunityId: input.commmunityId,
              praiserId: input.praiserId,
            ),
          );
          return praiseOrError;
        } on Exception catch (e) {
          return Left(e);
        }
      });
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
