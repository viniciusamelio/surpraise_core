import '../../../../core/events/base_event.dart';

class UserCreated implements DomainEvent {
  UserCreated({
    required this.email,
    required this.id,
    required this.tag,
  });

  final String tag;
  final String id;
  final String email;

  @override
  String get name => "User $tag created";
}
