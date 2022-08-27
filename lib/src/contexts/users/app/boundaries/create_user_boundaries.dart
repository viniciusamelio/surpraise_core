class CreateUserInput {
  CreateUserInput({
    required this.tag,
    required this.name,
    required this.email,
    this.id,
  });
  final String tag;
  final String name;
  final String email;
  String? id;
}

class CreateUserOutput {
  CreateUserOutput({
    required this.tag,
    required this.name,
    required this.email,
    required this.id,
  });
  final String tag;
  final String name;
  final String email;
  final String id;
}
