import 'package:surpraise_core/src/core/events/base_event.dart';

class UserInactivated implements DomainEvent {
  UserInactivated(this.id);
  final String id;

  @override
  String get name => "User $id inactivated";
}
