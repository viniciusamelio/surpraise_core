class AnswerInviteInput {
  const AnswerInviteInput({
    required this.id,
    required this.accepted,
  });
  final String id;
  final bool accepted;
}

class AnswerInviteOutput {
  const AnswerInviteOutput();
  final String message = "This invite was answered!";
}

class FindInviteOutput {
  const FindInviteOutput({
    required this.id,
    required this.communityId,
    required this.status,
    required this.role,
    required this.memberId,
  });
  final String id;
  final String communityId;
  final String status;
  final String role;
  final String memberId;
}
