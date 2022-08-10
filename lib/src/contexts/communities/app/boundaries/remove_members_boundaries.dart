class RemoveMembersInput {
  RemoveMembersInput({
    required this.communityId,
    required this.memberIds,
  });

  final List<String> memberIds;
  final String communityId;
}

class RemoveMembersOutput {
  final String message = "Members removed successfully";
}
