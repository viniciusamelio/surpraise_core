// ignore_for_file: prefer_final_fields

import '../../../../core/entities/base_entity.dart';
import '../../../../core/exceptions/domain_exception.dart';
import '../../../../core/value_objects/id.dart';
import '../value_objects/description.dart';
import '../value_objects/title.dart';
import 'member.dart';

class Community implements Entity {
  Community({
    required Id id,
    required Id ownerId,
    required this.description,
    required this.title,
    required this.members,
    this.invitedMembers = const [],
  })  : _ownerId = ownerId,
        _id = id;

  Id _id;
  Id _ownerId;
  Title title;
  Description description;
  final List<Member> members;
  final List<Member> invitedMembers;

  Id get ownerId => _ownerId;
  Id get id => _id;

  void invite(Member member) {
    final currentMember =
        members.where((element) => element.id == member.id).singleOrNull;
    if (currentMember != null && member.role == currentMember.role) {
      throw DomainException(
        "This member is already a community member and has this same role",
      );
    } else if (invitedMembers
        .where((element) => element.id == member.id)
        .isNotEmpty) {
      throw DomainException("Member was already invited");
    }
    invitedMembers.add(member);
  }

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
