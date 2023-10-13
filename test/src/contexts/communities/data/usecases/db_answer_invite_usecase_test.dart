import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/surpraise_core.dart';
import 'package:test/test.dart';

class MockAnswerInviteRepo extends Mock implements AnswerInviteRepository {}

void main() {
  group("Answer invite usecase: ", () {
    late final AnswerInviteUsecase sut;
    late final AnswerInviteRepository repository;

    setUpAll(() {
      repository = MockAnswerInviteRepo();
      sut = DbAnswerInviteUsecase(answerInviteRepository: repository);
      registerFallbackValue(
          AnswerInviteInput(id: faker.guid.guid(), accepted: true));
    });

    setUp(() {
      when(
        () => repository.findInvite(any()),
      ).thenAnswer(
        (invocation) async => Right(
          FindInviteOutput(
            id: faker.guid.guid(),
            communityId: faker.guid.guid(),
            status: "accepted",
            role: "member",
            memberId: faker.guid.guid(),
          ),
        ),
      );
    });
    test(
      "Sut should return left when invite is not pending",
      () async {
        final result = await sut(
          AnswerInviteInput(
            id: faker.guid.guid(),
            accepted: true,
          ),
        );

        expect(result.isLeft(), isTrue);
        expect(
          result.fold((left) => left, (right) => null),
          isA<DomainException>(),
        );
      },
    );

    test(
      "Sut should return right when invite is pending",
      () async {
        when(
          () => repository.answerInvite(any()),
        ).thenAnswer(
          (invocation) async => Right(AnswerInviteOutput()),
        );
        when(
          () => repository.findInvite(any()),
        ).thenAnswer(
          (invocation) async => Right(
            FindInviteOutput(
              id: faker.guid.guid(),
              communityId: faker.guid.guid(),
              status: "pending",
              role: "member",
              memberId: faker.guid.guid(),
            ),
          ),
        );

        final result = await sut(
          AnswerInviteInput(
            id: faker.guid.guid(),
            accepted: true,
          ),
        );

        expect(result.isRight(), isTrue);
      },
    );
  });
}
