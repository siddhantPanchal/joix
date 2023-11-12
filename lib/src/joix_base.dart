import 'error.dart';
import 'identifier.dart';
import 'types/interfaces/defaultable.dart';
import 'types/num.dart';
import 'types/string.dart';
import 'validator/priority.dart';
import 'validator/validator.dart';
import 'validator/validator_compressor.dart';
import 'validator/validator_options.dart';

abstract class JoiX<T> implements Defaultable<T> {
  ValidatorCompressor<T> get compressor;
  T? get value;

  static JoiStringX string(String? value) {
    return JoiStringX(value: value);
  }

  static JoiNumberX number(num? value) {
    return JoiNumberX(value: value);
  }

  JoiX<T> required({String? message}) {
    compressor.registerValidator(JoiValidator(
      options: const ValidatorOptions(priority: JoiValidatorPriority.medium),
      identifier: JoiIdentifier.required,
      nullValidator: () {
        throw JoiTypeException(message ?? "value is required");
      },
    ));
    return this;
  }

  @override
  JoiX<T> defaultValue(T value) {
    compressor.registerValidator(
      JoiValidator(
        options: const ValidatorOptions(priority: JoiValidatorPriority.high),
        identifier: JoiIdentifier.defaultValue,
        nullValidator: () => value,
      ),
    );
    return this;
  }
  // JoiX valid<S>(List<S> validValues,
  //     {String? message, bool caseSensitive = true});

  JoiResult<T> validate() {
    return compressor.validate(value);
  }
}

class JoiResult<T> {
  final bool _isSuccess;
  bool get isSuccess => _isSuccess;

  final JoiTypeException? _error;
  JoiTypeException? get error => _error;

  final T? _value;
  T? get value => _isSuccess ? _value : throw _error!;

  JoiResult({
    required bool isSuccess,
    required JoiTypeException? error,
    required T? value,
  })  : _value = value,
        _error = error,
        _isSuccess = isSuccess;

  @override
  String toString() {
    return {
      "value": _value,
      "result": _isSuccess,
      "error": _error?.message,
    }.toString();
  }
}
