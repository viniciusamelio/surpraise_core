import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';
import 'package:surpraise_core/src/contexts/communities/app/boundaries/boundaries.dart';
import 'package:surpraise_core/src/contexts/communities/data/protocols/protocols.dart';
import 'package:surpraise_core/src/contexts/communities/data/usecases/usecases.dart';
import 'package:surpraise_core/src/core/core.dart';
import 'package:test/test.dart';

class MockLeaveCommunityRepo extends Mock implements LeaveCommunityRepository {}

void main() {
  group("Leave community usecase: ", () {
    late final DbLeaveCommunityUsecase sut;
    late final LeaveCommunityRepository repository;

    setUpAll(
      () async {
        repository = MockLeaveCommunityRepo();
        sut = DbLeaveCommunityUsecase(
          leaveCommunityRepository: repository,
        );
        registerFallbackValue(LeaveCommunityInput(
          memberId: faker.guid.guid(),
          communityId: faker.guid.guid(),
          memberRole: "member",
        ));
      },
    );

    test(
      "Sut should return left when repository does so",
      () async {
        when(() => repository.leave(any())).thenAnswer(
          (_) async => Left(
            Exception(),
          ),
        );

        final result = await sut(
          LeaveCommunityInput(
            memberId: faker.guid.guid(),
            communityId: faker.guid.guid(),
            memberRole: "member",
          ),
        );

        expect(result.isLeft(), isTrue);
      },
    );

    test(
      "Sut should return left when members count is greater than 1 and user is THE community owner",
      () async {
        final id = faker.guid.guid();
        when(() => repository.getCommunityDetails(any())).thenAnswer(
          (_) async => Right(
            CommunityDetailsOutput(
              membersCount: 2,
              ownerId: id,
            ),
          ),
        );

        final result = await sut(
          LeaveCommunityInput(
            memberId: id,
            communityId: faker.guid.guid(),
            memberRole: "owner",
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
      "Sut should return left when get members request failes",
      () async {
        when(() => repository.getCommunityDetails(any())).thenAnswer(
          (_) async => Left(
            Exception(),
          ),
        );

        final result = await sut(
          LeaveCommunityInput(
            memberId: faker.guid.guid(),
            communityId: faker.guid.guid(),
            memberRole: "owner",
          ),
        );

        expect(result.isLeft(), isTrue);
        expect(
          result.fold((left) => left, (right) => null),
          isA<Exception>(),
        );
      },
    );

    test(
      "Sut should return right when there is more than one member left but user is not an owner",
      () async {
        when(() => repository.getCommunityDetails(any())).thenAnswer(
          (_) async => Right(CommunityDetailsOutput(
            membersCount: 4,
            ownerId: faker.guid.guid(),
          )),
        );
        when(() => repository.leave(any())).thenAnswer(
          (_) async => Right(
            LeaveCommunityOutput(""),
          ),
        );

        final result = await sut(
          LeaveCommunityInput(
            memberId: faker.guid.guid(),
            communityId: faker.guid.guid(),
            memberRole: "moderator",
          ),
        );

        expect(result.isRight(), isTrue);
      },
    );

    test(
      "Sut should return right when members count is greater than 1 and user is an owner but not the founder",
      () async {
        final id = faker.guid.guid();
        when(() => repository.leave(any())).thenAnswer(
          (_) async => Right(
            LeaveCommunityOutput(""),
          ),
        );
        when(() => repository.getCommunityDetails(any())).thenAnswer(
          (_) async => Right(
            CommunityDetailsOutput(
              membersCount: 2,
              ownerId: id,
            ),
          ),
        );

        final result = await sut(
          LeaveCommunityInput(
            memberId: faker.guid.guid(),
            communityId: faker.guid.guid(),
            memberRole: "owner",
          ),
        );

        expect(result.isRight(), isTrue);
      },
    );
  });
}
