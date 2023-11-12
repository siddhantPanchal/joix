

import '../identifier.dart';
import 'validator_options.dart';

typedef NullValidatorFunction<T> = T? Function();
typedef ValidatorNonNullFunction<T> = void Function(T value);
typedef TransformFunction<T> = T Function(T value);

class JoiValidator<T> {
  late final String _identifier;
  String get identifier => this._identifier;

  final NullValidatorFunction? _nullValidator;
  final ValidatorNonNullFunction<T>? _validator;
  final TransformFunction<T>? _beforeValidationTransformer;
  final TransformFunction<T>? _afterValidationTransformer;

  final ValidatorOptions _options;
  ValidatorOptions get options => this._options;

  JoiValidator(
      {String? identifier,
      NullValidatorFunction<T>? nullValidator,
      ValidatorNonNullFunction<T>? validator,
      TransformFunction<T>? beforeValidation,
      TransformFunction<T>? afterValidation,
      ValidatorOptions options = const ValidatorOptions()})
      : assert(
          !(nullValidator == null && validator == null),
          "both validator cannot be null",
        ),
        _nullValidator = nullValidator,
        _validator = validator,
        _beforeValidationTransformer = beforeValidation,
        _afterValidationTransformer = afterValidation,
        _identifier = identifier ?? JoiIdentifier.generate,
        _options = options;

  T? call(T? value) {
    T? newValue;
    if (value == null) {
      newValue = _nullValidator?.call() ?? value;
    } else {
      newValue = _beforeValidationTransformer?.call(value) ?? value;
      _validator?.call(newValue);
      newValue = _afterValidationTransformer?.call(value) ?? value;
    }
    return newValue;
  }
}
