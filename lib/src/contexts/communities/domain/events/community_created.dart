import 'package:surpraise_core/src/contexts/communities/app/boundaries/create_community_boundaries.dart';
import 'package:surpraise_core/src/core/events/base_event.dart';

class CommunityCreated implements DomainEvent {
  CommunityCreated(
    this.data,
  );

  @override
  String get name => "Community Created";

  final CreateCommunityOutput data;
}
