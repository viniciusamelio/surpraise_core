import 'package:surpraise_core/src/core/events/base_event.dart';

class CommunityDeleted implements DomainEvent {
  CommunityDeleted({
    required this.communityId,
  });

  final String communityId;

  @override
  String get name => "Community $communityId Deleted";
}
