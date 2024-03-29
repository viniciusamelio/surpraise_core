import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/value_objects/base_value_object.dart';

enum TopicValues {
  tech("#tech"),
  kindness("#kindness"),
  thanks("#thanks"),
  recognition("#recognition"),
  randomness("#randomness"),
  partnership("#partnership"),
  motivational("#motivational"),
  surprise("#surprise"),
  finance("#finance");

  const TopicValues(this.value);

  final String value;

  factory TopicValues.fromString(String value) =>
      values.firstWhere((element) => "#${element.name}" == value);
}

class Topic extends Equatable implements ValueObject<String> {
  Topic(String value) {
    _validate(value);
    _value = value;
  }

  late final String _value;

  void _validate(String value) {
    if (value.isEmpty) {
      throw ValidationException("Invalid topic");
    } else if (value[0] != "#") {
      throw ValidationException("A topic must start with '#'");
    }
    TopicValues.fromString(value);
  }

  @override
  List<Object?> get props => [_value];
}
