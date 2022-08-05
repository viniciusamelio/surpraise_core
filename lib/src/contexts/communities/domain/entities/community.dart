import 'package:surpraise_core/src/contexts/communities/domain/entities/member.dart';
import 'package:surpraise_core/src/contexts/communities/domain/value_objects/description.dart';
import 'package:surpraise_core/src/core/entities/base_entity.dart';
import 'package:surpraise_core/src/core/value_objects/id.dart';

import '../../../../core/exceptions/domain_exception.dart';
import '../value_objects/title.dart';

class Community implements Entity {
  Community({
    required this.id,
    required Id ownerId,
    required this.description,
    required this.title,
    required this.members,
  }) : _ownerId = ownerId;

  final Id id;
  Id _ownerId;
  Title title;
  Description description;
  final List<Member> members;

  Id get ownerId => _ownerId;

  void changeOwner(Id newOwnerId) {
    if (ownerId == newOwnerId) {
      throw DomainException(
        "A community owner cannot be changed to him or herself",
      );
    }
    _ownerId = newOwnerId;
  }

  void addMember(Member member, int planMemberLimit) {
    if (members.length >= planMemberLimit) {
      throw DomainException(
        "Community member limit reached, upgrade your plan to add more members",
      );
    }
    members.add(member);
  }

  void removeMember(Id memberId) {
    members.removeWhere((member) => member.id == memberId);
  }
}
