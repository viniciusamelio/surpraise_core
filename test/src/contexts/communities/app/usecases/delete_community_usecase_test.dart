import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/delete_community_boundaries.dart';
import 'package:fpdart/src/either.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/find_community_boundaries.dart';
import 'package:surpraise_core/src/contexts/communities/app/usecases/delete_community_usecase.dart';
import 'package:surpraise_core/src/contexts/communities/data/protocols/protocols.dart';
import 'package:surpraise_core/src/core/exceptions/domain_exception.dart';
import 'package:test/test.dart';

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

class CommunityRepository extends Mock
    implements DeleteCommunityRepository, FindCommunityRepository {}

void main() {
  late DeleteCommunityUsecase sut;
  late DeleteCommunityRepository deleteCommunityRepository;
  late FindCommunityRepository findCommunityRepository;
  group("Delete Community Usecase: ", () {
    final input = FindCommunityInput(
      id: faker.guid.guid(),
    );
    final output = FindCommunityOutput(
      id: faker.guid.guid(),
      ownerId: faker.guid.guid(),
      description: faker.lorem.word(),
      title: faker.lorem.word(),
      members: [],
    );
    setUp(() {
      deleteCommunityRepository = CommunityRepository();
      findCommunityRepository = CommunityRepository();
      sut = DbDeleteCommunityUsecase(
        deleteCommunityRepository: deleteCommunityRepository,
        findCommunityRepository: findCommunityRepository,
      );

      registerFallbackValue(
        input,
      );
      registerFallbackValue(
        DeleteCommunityInput(id: input.id),
      );
    });

    void mockFind(Either<Exception, FindCommunityOutput> value) {
      when(
        () => findCommunityRepository.find(
          any(),
        ),
      ).thenAnswer(
        (invocation) async => value,
      );
    }

    void mockDelete(Either<Exception, DeleteCommunityOutput> value) {
      when(
        (() => deleteCommunityRepository.delete(
              any(),
            )),
      ).thenAnswer(
        (invocation) async => value,
      );
    }

    test("Should return left if find does so", () async {
      mockFind(
        Left(
          Exception(),
        ),
      );

      final result = await sut(
        DeleteCommunityInput(
          id: input.id,
        ),
      );

      expect(result.isLeft(), isTrue);
    });

    test("Should return left if community has more than one member", () async {
      mockFind(
        Right(
          output
            ..members.addAll(
              [
                FindCommunityMemberDto(
                  id: faker.guid.guid(),
                  communityId: output.id,
                  role: "admin",
                ),
                FindCommunityMemberDto(
                  id: faker.guid.guid(),
                  communityId: output.id,
                  role: "user",
                ),
              ],
            ),
        ),
      );

      final result = await sut(
        DeleteCommunityInput(
          id: input.id,
        ),
      );

      expect(result.isLeft(), isTrue);
      expect(result.fold((l) => l, (r) => null), isA<DomainException>());
    });

    test("Should return left if delete repo does so", () async {
      mockFind(
        Right(output),
      );
      mockDelete(
        Left(
          Exception(),
        ),
      );

      final result = await sut(
        DeleteCommunityInput(
          id: input.id,
        ),
      );

      expect(result.isLeft(), isTrue);
    });
  });
}
