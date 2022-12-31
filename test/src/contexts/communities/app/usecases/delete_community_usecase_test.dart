import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart'
    hide equals;
import 'package:surpraise_core/surpraise_core.dart';
import 'package:test/test.dart';

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
        deleteCommunityService: DeleteCommunityService(),
        eventBus: StreamEventBus(),
      );

      registerFallbackValue(
        input,
      );
      registerFallbackValue(
        DeleteCommunityInput(
          id: input.id,
        ),
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
                  role: "owner",
                ),
                FindCommunityMemberDto(
                  id: faker.guid.guid(),
                  communityId: output.id,
                  role: "member",
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

    test("SUT Should return right when everything goes ok", () async {
      mockFind(
        Right(output..members.removeAt(1)),
      );
      mockDelete(
        Right(
          DeleteCommunityOutput(
            communityId: output.id,
          ),
        ),
      );

      final result = await sut(
        DeleteCommunityInput(
          id: input.id,
        ),
      );

      expect(result.isRight(), isTrue);
      result.fold((l) => null, (r) {
        expect(
          r.message,
          equals("Community ${output.id} deleted"),
        );
      });
    });
  });
}
