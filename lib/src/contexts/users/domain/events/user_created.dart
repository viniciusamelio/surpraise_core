import 'package:surpraise_core/src/contexts/users/app/boundaries/create_user_boundaries.dart';
import 'package:surpraise_core/src/core/events/base_event.dart';

class UserCreated implements DomainEvent {
  UserCreated({
    required this.data,
  });

  final CreateUserOutput data;

  @override
  String get name => "User ${data.tag} created";
}
