import '../../../../core/core.dart';
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
  const Member({
    required this.id,
    required this.communityId,
    required this.role,
  });

  final Id id;
  final Id communityId;
  final Role role;

  void leaveCommunity({
    required int communityMembersCount,
    required String ownerId,
  }) {
    if (id.value == ownerId && communityMembersCount > 1) {
      throw DomainException(
        "This member need to be the last one to leave this community",
      );
    }
  }
}
