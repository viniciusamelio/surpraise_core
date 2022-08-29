import 'package:surpraise_core/src/core/events/base_event.dart';

class MemberRemoved implements DomainEvent {
  MemberRemoved({
    required this.communityId,
    required this.memberId,
  });
  final String memberId;
  final String communityId;

  @override
  String get name => "Member $memberId removed from community $communityId";
}
