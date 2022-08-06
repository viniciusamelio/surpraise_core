class DeleteCommunityInput {
  DeleteCommunityInput({
    required this.id,
  });
  final String id;
}

class DeleteCommunityOutput {
  DeleteCommunityOutput({required String communityId})
      : message = "Community $communityId deleted";
  final String message;
}
