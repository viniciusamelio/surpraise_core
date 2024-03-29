import '../../../../core/core.dart';
import '../entities/entities.dart';

class InviteAggregate {
  InviteAggregate({
    required Community community,
    required Invite invite,
    required Member inviter,
  })  : _community = community,
        _inviter = inviter;
  final Community _community;
  final Member _inviter;

  void invite({
    required Member member,
  }) {
    if (_inviter.role.level <= member.role.level &&
        (_community.ownerId != _inviter.id)) {
      throw DomainException(
        "You do not have the needed permission to invite this member",
      );
    }
    _community.invite(member);
  }
}
