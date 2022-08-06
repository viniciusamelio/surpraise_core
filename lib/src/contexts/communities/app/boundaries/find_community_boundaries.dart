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

class FindCommunityOutput {
  FindCommunityOutput({
    required this.id,
    required this.ownerId,
    required this.description,
    required this.title,
    required this.members,
  });

  final String id;
  final String ownerId;
  final String description;
  final String title;
  final List<FindCommunityMemberDto> members;
}

class FindCommunityInput {
  FindCommunityInput({
    required this.id,
  });
  final String id;
}
