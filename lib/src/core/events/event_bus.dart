import 'package:surpraise_core/src/core/events/base_event.dart';
import 'package:surpraise_core/src/core/events/event_handler.dart';

abstract class EventBus {
  Future<void> addEvent(DomainEvent event);
  Future<void> addHandler(EventHandler handler);
}
