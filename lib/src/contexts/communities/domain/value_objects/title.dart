import 'package:surpraise_backend_dependencies/surpraise_backend_dependencies.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/value_objects/base_value_object.dart';

class Title extends Equatable implements ValueObject<String> {
  Title(String value) {
    if (value.isEmpty) {
      throw ValidationException("Invalid title");
    }
    _value = value;
  }
  late final String _value;

  String get value => _value;

  @override
  String toString() {
    return value;
  }

  @override
  List<Object?> get props => [_value];
}
