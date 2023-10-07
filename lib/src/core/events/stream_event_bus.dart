import 'dart:async';

import 'base_event.dart';
import 'event_bus.dart';
import 'event_handler.dart';

class StreamEventBus implements EventBus {
  final StreamController _streamController =
      StreamController<DomainEvent>.broadcast();

  Stream get stream => _streamController.stream;

  @override
  addEvent(DomainEvent event) async {
    _streamController.add(event);
  }

  @override
  addHandler(EventHandler<DomainEvent> handler) async {
    _streamController.stream.listen(
      (event) => handler(event),
    );
  }
}
