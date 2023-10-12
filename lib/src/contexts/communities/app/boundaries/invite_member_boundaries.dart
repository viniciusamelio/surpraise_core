class InviteMemberInput {
  const InviteMemberInput({
    required this.communityId,
    required this.memberId,
    required this.role,
  });

  final String communityId;
  final String memberId;
  final String role;
}

class InviteMemberOutput {
  const InviteMemberOutput();
  final String message = "User was invited!";
}
