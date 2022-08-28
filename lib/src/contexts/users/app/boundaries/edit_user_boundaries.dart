class EditUserInput {
  EditUserInput({
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

class EditUserOutput extends EditUserInput {
  EditUserOutput({
    required super.tag,
    required super.name,
    required super.email,
    required super.id,
  });
}
