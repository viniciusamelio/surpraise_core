class FindCommunityMemberDto {
  FindCommunityMemberDto({
    required this.id,
    required this.communityId,
    required this.role,
  });
  final String id;
  final String communityId;
  final String role;
}

class FindCommunityInviteDto {
  const FindCommunityInviteDto({
    required this.id,
    required this.memberId,
    required this.role,
  });
  final String id;
  final String memberId;
  final String role;
}

class FindCommunityOutput {
  FindCommunityOutput({
    required this.id,
    required this.ownerId,
    required this.description,
    required this.title,
    required this.members,
    this.invites = const [],
  });

  final String id;
  final String ownerId;
  final String description;
  final String title;
  final List<FindCommunityMemberDto> members;
  final List<FindCommunityInviteDto> invites;
}

class FindCommunityInput {
  FindCommunityInput({
    required this.id,
    this.withInvites = false,
  });
  final String id;
  final bool withInvites;
}
