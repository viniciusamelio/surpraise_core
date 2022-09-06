import 'package:surpraise_core/src/core/events/base_event.dart';

class CommunityCreated implements DomainEvent {
  CommunityCreated({
    required this.id,
    required this.ownerId,
    required this.title,
  });

  @override
  String get name => "Community Created";

  final String id;
  final String ownerId;
  final String title;
}
