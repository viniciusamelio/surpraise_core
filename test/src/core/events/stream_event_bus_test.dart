import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:surpraise_core/src/core/events/base_event.dart';
import 'package:surpraise_core/src/core/events/event_bus.dart';
import 'package:surpraise_core/src/core/events/event_handler.dart';
import 'package:surpraise_core/src/core/events/stream_event_bus.dart';

void main() {
  late EventBus sut;
  late MockedEventHandler mockedEventHandler;
  late Storage storage;
  late EmailClient emailClient;
  setUpAll(() {
    storage = MockStorage();
    emailClient = MockEmailClient();
    mockedEventHandler = MockedEventHandler(
      storage: storage,
    );
    sut = StreamEventBus();
    sut.addHandler(
      mockedEventHandler,
    );
  });

  group("Stream Event Bus: ", () {
    test("Should successfully handle MockEvent and call Storage.save",
        () async {
      final event = MockEvent();

      await sut.addEvent(event);

      verify(
        () => storage.save(event),
      ).called(1);
    });
    test("Should handle only the expected event", () async {
      await sut.addHandler(
        EmailEventHandler(
          emailClient: emailClient,
        ),
      );
      final event2 = SignUpEvent(
        email: faker.internet.email(),
      );
      final event = MockEvent();

      await sut.addEvent(event);
      await sut.addEvent(event2);

      verify(
        () => storage.save(event),
      ).called(1);
      verify(
        () => emailClient.sendWelcomeEmail(
          any(),
        ),
      ).called(1);
    });
  });
}

abstract class Storage {
  void save(dynamic value);
}

abstract class EmailClient {
  void sendWelcomeEmail(String emailAddress);
}

class MockStorage extends Mock implements Storage {}

class MockEvent extends Mock implements DomainEvent {}

class MockEmailClient extends Mock implements EmailClient {}

class SignUpEvent extends Mock implements DomainEvent {
  SignUpEvent({
    required this.email,
  });

  final String email;
}

class MockedEventHandler implements EventHandler<MockEvent> {
  MockedEventHandler({
    required this.storage,
  });

  final Storage storage;

  @override
  void call(DomainEvent event) {
    if (event is MockEvent) {
      storage.save(event);
    }
  }
}

class EmailEventHandler implements EventHandler<SignUpEvent> {
  EmailEventHandler({
    required this.emailClient,
  });
  final EmailClient emailClient;

  @override
  void call(DomainEvent event) {
    if (event is SignUpEvent) {
      emailClient.sendWelcomeEmail(event.email);
    }
  }
}
