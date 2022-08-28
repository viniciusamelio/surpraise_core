import 'dart:async';

import 'package:surpraise_core/src/core/events/base_event.dart';
import 'package:surpraise_core/src/core/events/event_bus.dart';
import 'package:surpraise_core/src/core/events/event_handler.dart';

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
