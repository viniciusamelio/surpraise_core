import "./entities/user.dart";

export "./value_objects/value_objects.dart";

class PraiseAggregateRoot {
  const PraiseAggregateRoot({
    required this.user,
  });

  final User user;
}
