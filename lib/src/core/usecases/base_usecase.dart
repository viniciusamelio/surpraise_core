import 'package:surpraise_core/src/core/events/base_event.dart';
import 'package:surpraise_core/src/core/events/event_bus.dart';

abstract class Usecase<T extends DomainEvent> {
  Usecase({
    required this.eventBus,
  });
  final EventBus eventBus;

  void notify(T event) {
    eventBus.addEvent(event);
  }
}
