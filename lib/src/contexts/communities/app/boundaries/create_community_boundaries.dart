class CreateCommunityInput {
  CreateCommunityInput({
    this.id,
    required this.description,
    required this.ownerId,
    required this.title,
    this.planMemberLimit = 50,
  });

  String? id;
  String ownerId;
  String description;
  String title;
  int planMemberLimit;
}

class CreateCommunityOutput {
  CreateCommunityOutput({
    required this.id,
    required this.description,
    required this.title,
    required this.members,
    required this.ownerId,
  }) : assert(members.isNotEmpty);

  final String id;
  final String ownerId;
  final String description;
  final String title;
  final List<Map> members;
}
