import '../../../../core/core.dart';
import '../../../../core/entities/base_entity.dart';
import '../../../../core/value_objects/id.dart';
import 'entities.dart';

enum InviteStatus {
  refused("refused"),
  accepted("accepted"),
  pending("pending");

  final String value;

  static InviteStatus fromString(String value) {
    return InviteStatus.values
        .singleWhere((element) => element.value == value.toLowerCase());
  }

  const InviteStatus(this.value);
}

class Invite implements Entity {
  Invite({
    required Id id,
    required Role role,
    required InviteStatus status,
  })  : _id = id,
        _role = role,
        _status = status;
  final Id _id;
  final Role _role;
  InviteStatus _status;

  Id get id => _id;
  Role get role => _role;
  InviteStatus get status => _status;

  void accept() {
    if (status != InviteStatus.pending) {
      throw DomainException("status must be pending");
    }
    _status = InviteStatus.accepted;
  }

  void refuse() {
    if (status != InviteStatus.pending) {
      throw DomainException("status must be pending");
    }
    _status = InviteStatus.refused;
  }
}
