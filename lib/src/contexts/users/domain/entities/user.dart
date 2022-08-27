import 'package:surpraise_core/src/contexts/users/domain/value_objects/value_objects.dart';
import 'package:surpraise_core/src/core/entities/base_entity.dart';
import 'package:surpraise_core/src/core/value_objects/id.dart';

class User implements Entity {
  User({
    required Id id,
    required Tag tag,
    required this.name,
    required this.email,
  })  : _id = id,
        _tag = tag;

  final Id _id;
  final Tag _tag;
  Name name;
  Email email;

  Id get id => _id;
  Tag get tag => _tag;

  void changeName(Name newName) => name = newName;
  void changeEmail(Email newEmail) => email = newEmail;
}
