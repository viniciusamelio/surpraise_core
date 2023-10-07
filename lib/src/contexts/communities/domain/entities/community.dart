// ignore_for_file: prefer_final_fields

import 'package:surpraise_core/src/contexts/communities/domain/entities/member.dart';
import 'package:surpraise_core/src/contexts/communities/domain/value_objects/description.dart';
import 'package:surpraise_core/src/core/entities/base_entity.dart';
import 'package:surpraise_core/src/core/value_objects/id.dart';

import '../../../../core/exceptions/domain_exception.dart';
import '../value_objects/title.dart';

class Community implements Entity {
  Community({
    required Id id,
    required Id ownerId,
    required this.description,
    required this.title,
    required this.members,
  })  : _ownerId = ownerId,
        _id = id;

  Id _id;
  Id _ownerId;
  Title title;
  Description description;
  final List<Member> members;

  Id get ownerId => _ownerId;
  Id get id => _id;

  void changeOwner(Id newOwnerId) {
    if (ownerId == newOwnerId) {
      throw DomainException(
        "A community owner cannot be changed to him or herself",
      );
    }
    _ownerId = newOwnerId;
  }

  void addMember(Member member, int planMemberLimit) {
    if (members.length > planMemberLimit) {
      throw DomainException(
        "Community member limit reached, upgrade your plan to add more members",
      );
    }
    members.add(member);
  }

  void removeMember({
    required Member moderator,
    required Member member,
  }) {
    if (moderator.role.level > member.role.level || ownerId == moderator.id) {
      members.removeWhere((element) => element.id == member.id);
      return;
    }

    throw DomainException(
      "You do not have the needed permission to remove this member",
    );
  }
}
