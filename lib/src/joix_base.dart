import '../joix.dart';
import 'validator/priority.dart';
import 'validator/validator.dart';
import 'validator/validator_compressor.dart';
import 'validator/validator_options.dart';

abstract class JoiX<T> implements Defaultable<T> {
  final ValidatorCompressor<T> _compressor;
  T? get value;

  String? name;

  JoiX(this._compressor);

  JoiX<T> required({String? message}) {
    _compressor.registerValidator(JoiValidator(
      options: const ValidatorOptions(priority: JoiValidatorPriority.medium),
      identifier: JoiIdentifier.required,
      nullValidator: () {
        throw JoiTypeException(
          message ??
              "The ${name ?? 'value'} is required. Please provide a valid value.",
        );
      },
    ));
    return this;
  }

  @override
  JoiX<T> defaultValue(T value) {
    _compressor.registerValidator(
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
    return _compressor.validate(value);
  }

  @override
  String toString() {
    return value.toString();
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
