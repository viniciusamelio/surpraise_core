import 'package:surpraise_core/src/core/events/base_event.dart';

class PraiseSent implements DomainEvent {
  PraiseSent({
    required this.id,
    required this.commmunityId,
    required this.praisedId,
    required this.praiserId,
  });
  final String commmunityId;
  final String praiserId;
  final String praisedId;
  final String id;

  @override
  String get name =>
      "User $praisedId was praised by $praiserId, from community $commmunityId";
}
