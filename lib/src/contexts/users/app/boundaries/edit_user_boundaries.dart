class EditUserInput {
  const EditUserInput({
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

class EditUserOutput {
  const EditUserOutput({
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
