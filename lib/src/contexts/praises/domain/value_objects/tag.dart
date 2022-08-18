import 'package:equatable/equatable.dart';
import 'package:surpraise_core/src/core/exceptions/exceptions.dart';
import 'package:surpraise_core/src/core/value_objects/base_value_object.dart';

class Tag extends Equatable implements ValueObject<String> {
  Tag(String value) {
    _validate(value);
    _value = value;
  }
  late final String _value;

  void _validate(String value) {
    if (value.isEmpty) {
      throw ValidationException("Invalid tag");
    } else if (value[0] != "@") {
      throw ValidationException("Invalid tag, tags must start with '@'");
    } else if (value.length < 4) {
      throw ValidationException(
        "Invalid tag, tags must contains at least 4 characters",
      );
    } else if (value.length > 12) {
      throw ValidationException(
        "Invalid tag, tags must not contains more than 20 characters",
      );
    }
  }

  @override
  List<Object?> get props => [
        _value,
      ];
}
