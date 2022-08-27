import 'package:surpraise_core/src/contexts/users/app/boundaries/create_user_boundaries.dart';

import 'package:surpraise_core/src/contexts/users/domain/value_objects/value_objects.dart';
import 'package:surpraise_core/src/core/value_objects/id.dart';

import '../../domain/entities/user.dart';

abstract class UserFactory {
  static User fromCreateInputDto(CreateUserInput input, String id) {
    return User(
      id: Id(id),
      tag: Tag(input.tag),
      name: Name(input.name),
      email: Email(input.email),
    );
  }
}
