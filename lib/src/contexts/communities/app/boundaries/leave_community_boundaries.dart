class LeaveCommunityInput {
  const LeaveCommunityInput({
    required this.memberId,
    required this.communityId,
    required this.memberRole,
  });
  final String memberId;
  final String communityId;
  final String memberRole;
}

class LeaveCommunityOutput {
  const LeaveCommunityOutput(this.communityId);
  final String message = "Community left successfully";
  final String communityId;
}

class CommunityDetailsOutput {
  const CommunityDetailsOutput({
    required this.membersCount,
    required this.ownerId,
  });
  final int membersCount;
  final String ownerId;
}
