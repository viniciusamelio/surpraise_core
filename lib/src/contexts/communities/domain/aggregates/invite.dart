import '../entities/entities.dart';

class InviteAggregate {
  InviteAggregate({
    required Community community,
    required Invite invite,
  })  : _community = community,
        _invite = invite;
  final Community _community;
  final Invite _invite;

  void invite({
    required Member member,
  }) {
    _community.invite(member);
  }

  void answerInvite({required bool accept}) {
    if (accept) {
      _invite.accept();
      return;
    }
    _invite.refuse();
  }
}
