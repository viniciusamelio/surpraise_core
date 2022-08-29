import 'package:surpraise_core/src/contexts/praises/app/boundaries/praise_boundaries.dart';
import 'package:surpraise_core/src/core/events/base_event.dart';

class PraiseSent implements DomainEvent {
  PraiseSent(
    this.data,
  );
  final PraiseInput data;

  @override
  String get name =>
      "User ${data.praisedId} was praised by ${data.praiserId}, from community ${data.commmunityId}";
}
