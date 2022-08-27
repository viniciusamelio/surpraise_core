import 'package:equatable/equatable.dart';
import 'package:string_validator/string_validator.dart';
import 'package:surpraise_core/src/core/exceptions/validation_exception.dart';
import 'package:surpraise_core/src/core/value_objects/base_value_object.dart';

class Email extends Equatable implements ValueObject<String> {
  Email(String value) {
    _validate(value);
    _value = value;
  }

  void _validate(String value) {
    if (!isEmail(value)) {
      throw ValidationException("Invalid e-mail");
    }
  }

  late final String _value;

  String get value => _value;

  @override
  List<Object?> get props => throw UnimplementedError();
}
