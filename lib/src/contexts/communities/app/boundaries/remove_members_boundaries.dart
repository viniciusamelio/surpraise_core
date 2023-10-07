import '../../domain/entities/entities.dart';

class RemoveMembersInput {
  RemoveMembersInput({
    required this.communityId,
    required this.members,
    required this.moderator,
    required this.reason,
  });

  final List<MemberDto> members;
  final MemberDto moderator;
  final String communityId;
  final String reason;
}

class MemberDto {
  const MemberDto({
    required this.id,
    required this.role,
  });
  final String id;
  final Role role;
}

class RemoveMembersOutput {
  final String message = "Members removed successfully";
}
