import 'package:faker/faker.dart';
import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_core/surpraise_core.dart';
import 'package:test/test.dart';

class MockPraiseRepository extends Mock
    implements CreatePraiseRepository, FindPraiseUsersRepository {}

class MockIdService extends Mock implements IdService {}

void main() {
  late PraiseUsecase sut;
  late IdService mockIdService;
  late MockPraiseRepository praiseRepository;

  final input = PraiseInput(
    commmunityId: faker.guid.guid(),
    message: faker.lorem.words(5).toString(),
    praisedId: faker.guid.guid(),
    praiserId: faker.guid.guid(),
    topic: "#tech",
  );

  group("Praise Usecase: ", () {
    setUp(() {
      mockIdService = MockIdService();
      praiseRepository = MockPraiseRepository();
      sut = DbPraiseUsecase(
        createPraiseRepository: praiseRepository,
        idService: mockIdService,
        findPraiseUsersRepository: praiseRepository,
      );

      registerFallbackValue(input);
    });

    void mockId() {
      when(
        () => mockIdService.generate(),
      ).thenAnswer(
        (invocation) async => faker.guid.guid(),
      );
    }

    void mockFindPraiseUsers(Either<Exception, FindPraiseUsersDto> value) =>
        when(
          () => praiseRepository.find(
            praiserId: input.praiserId,
            praisedId: input.praisedId,
          ),
        ).thenAnswer(
          (invocation) async => value,
        );

    void mockPraise(Either<Exception, PraiseOutput> value) => when(
          () => praiseRepository.create(any()),
        ).thenAnswer(
          (invocation) async => value,
        );
    test('Should return left when find users repo does so', () async {
      mockId();
      mockFindPraiseUsers(
        Left(
          Exception(),
        ),
      );

      final result = await sut(
        input,
      );

      expect(result.isLeft(), isTrue);
    });

    test("Should return left when create praise repo does so", () async {
      mockId();
      mockFindPraiseUsers(
        Right(
          FindPraiseUsersDto(
            praisedDto: PraisedDto(
              tag: "@viniciusamelio",
              communities: [
                input.commmunityId,
              ],
            ),
            praiserDto: PraiserDto(
              tag: "@joaozinho",
              communities: [
                input.commmunityId,
              ],
            ),
          ),
        ),
      );
      mockPraise(
        Left(
          Exception(),
        ),
      );

      final result = await sut(input);

      expect(result.isLeft(), isTrue);
    });

    test(
      "Should return left when trying to praise an user which is not member of the same community",
      () async {
        mockId();
        mockFindPraiseUsers(
          Right(
            FindPraiseUsersDto(
              praisedDto: PraisedDto(
                tag: "@viniamelio",
                communities: [
                  input.commmunityId,
                ],
              ),
              praiserDto: PraiserDto(
                tag: "@joaozinho",
                communities: [
                  faker.guid.guid(),
                ],
              ),
            ),
          ),
        );

        final result = await sut(input);

        expect(result.isLeft(), isTrue);
        expect(result.fold((l) => l, (r) => r), isA<DomainException>());
      },
    );

    test(
      "Should return left when an user tries to praise him/herself",
      () async {
        mockId();
        mockFindPraiseUsers(
          Right(
            FindPraiseUsersDto(
              praisedDto: PraisedDto(
                tag: "@viniamelio",
                communities: [
                  input.commmunityId,
                ],
              ),
              praiserDto: PraiserDto(
                tag: "@viniamelio",
                communities: [
                  input.commmunityId,
                ],
              ),
            ),
          ),
        );

        final result = await sut(input);

        expect(result.isLeft(), isTrue);
        expect(result.fold((l) => l, (r) => r), isA<ApplicationException>());
      },
    );

    test(
      "Should return right when everything goes ok",
      () async {
        mockId();
        mockFindPraiseUsers(
          Right(
            FindPraiseUsersDto(
              praisedDto: PraisedDto(
                tag: "@viniamelio",
                communities: [
                  input.commmunityId,
                ],
              ),
              praiserDto: PraiserDto(
                tag: "@jpgames",
                communities: [
                  input.commmunityId,
                ],
              ),
            ),
          ),
        );
        mockPraise(
          Right(
            PraiseOutput(),
          ),
        );

        final result = await sut(input);

        expect(result.isRight(), isTrue);
        expect(result.fold((l) => l, (r) => r), isA<PraiseOutput>());
      },
    );
  });
}
