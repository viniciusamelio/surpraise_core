import 'package:surpraise_core/src/core/entities/base_entity.dart';
import 'package:surpraise_core/src/core/value_objects/id.dart';

enum Role {
  member("member"),
  moderator("mod"),
  admin("owner");

  const Role(this.value);

  final String value;

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
