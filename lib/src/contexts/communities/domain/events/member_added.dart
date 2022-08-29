import 'package:surpraise_core/src/core/events/base_event.dart';

class MemberAdded implements DomainEvent {
  MemberAdded({
    required this.communityId,
    required this.memberId,
  });
  final String communityId;
  final String memberId;

  @override
  String get name => "Member added";
}
