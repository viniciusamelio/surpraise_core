class InviteMemberInput {
  const InviteMemberInput({
    required this.communityId,
    required this.memberId,
    required this.role,
    required this.inviterId,
  });

  final String communityId;
  final String memberId;
  final String role;
  final String inviterId;
}

class InviteMemberOutput {
  const InviteMemberOutput();
  final String message = "User was invited!";
}
