class CreateCommunityInput {
  CreateCommunityInput({
    this.id,
    required this.description,
    required this.ownerId,
    required this.title,
  });

  String? id;
  String ownerId;
  String description;
  String title;
}

class CreateCommunityOutput {}
