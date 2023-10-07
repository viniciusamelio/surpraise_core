import 'base_event.dart';
import 'event_handler.dart';

abstract class EventBus {
  Future<void> addEvent(DomainEvent event);
  Future<void> addHandler(EventHandler handler);
}
