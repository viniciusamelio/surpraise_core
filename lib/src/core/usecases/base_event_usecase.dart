import 'package:surpraise_core/src/core/events/base_event.dart';
import 'package:surpraise_core/src/core/events/event_bus.dart';

abstract class EventEmitterUsecase<T extends DomainEvent> {
  EventEmitterUsecase({
    required this.eventBus,
  });

  final EventBus eventBus;

  void notify(T event) {
    eventBus.addEvent(event);
  }
}
