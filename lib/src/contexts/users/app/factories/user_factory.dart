import '../../../../core/value_objects/id.dart';
import '../../domain/entities/user.dart';
import '../../domain/value_objects/value_objects.dart';
import '../boundaries/create_user_boundaries.dart';
import '../boundaries/edit_user_boundaries.dart';

abstract class UserFactory {
  static User fromCreateInputDto(CreateUserInput input, String id) {
    return User(
      id: Id(id),
      tag: Tag(input.tag),
      name: Name(input.name),
      email: Email(input.email),
    );
  }

  static User fromEditInputDto(EditUserInput input) {
    return User(
      id: Id(input.id),
      tag: Tag(input.tag),
      name: Name(input.name),
      email: Email(input.email),
    );
  }
}
