import '../../../../core/entities/base_entity.dart';
import '../../../../core/value_objects/id.dart';

enum Role {
  member("member", 1),
  moderator("moderator", 2),
  admin("owner", 3);

  const Role(
    this.value,
    this.level,
  );

  final String value;
  final int level;

  factory Role.fromString(String value) =>
      values.firstWhere((element) => element.value == value);
}

class Member implements Entity {
  Member({
    required this.id,
    required this.communityId,
    required this.role,
  });

  final Id id;
  final Id communityId;
  final Role role;
}
