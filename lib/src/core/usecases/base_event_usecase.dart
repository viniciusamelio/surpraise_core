import 'package:surpraise_core/src/core/events/base_event.dart';
import 'package:surpraise_core/src/core/events/event_bus.dart';
import 'package:surpraise_core/src/core/events/stream_event_bus.dart';

abstract class EventEmitterUsecase<T extends DomainEvent> {
  final EventBus eventBus = StreamEventBus();

  void notify(T event) {
    eventBus.addEvent(event);
  }
}
