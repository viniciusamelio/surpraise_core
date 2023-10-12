import 'create_community_boundaries.dart';

class UpdateCommunityInput extends CreateCommunityInput {
  UpdateCommunityInput({
    required super.description,
    required super.ownerId,
    required super.title,
    required super.imageUrl,
    required super.id,
  });
}

class UpdateCommunityOutput {
  const UpdateCommunityOutput({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.title,
  });

  final String id;
  final String description;
  final String title;
  final String imageUrl;
}
