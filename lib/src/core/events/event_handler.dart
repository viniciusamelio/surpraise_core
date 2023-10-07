import 'base_event.dart';

abstract class EventHandler<T extends DomainEvent> {
  void call(DomainEvent event);
}
