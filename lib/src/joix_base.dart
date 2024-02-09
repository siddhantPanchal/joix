// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';
import 'package:joix/src/currencies.dart';
import 'package:joix/src/error.dart';
import 'package:joix/src/identifier.dart';
import 'package:joix/src/types/interfaces/interfaces.dart';

import 'validator/priority.dart';
import 'validator/validator.dart';
import 'validator/validator_compressor.dart';
import 'validator/validator_options.dart';

part "types/map.dart";
part "types/num.dart";
part "types/ref.dart";
part "types/string.dart";

// ignore: camel_case_types
typedef joi = JoiX;

mixin JoiX<T> implements Defaultable<T> {
  late final ValidatorCompressor<T> _compressor;
  T? _value;
  get value => this._value;

  String? name;

  static JoiStringX string() {
    return JoiStringX(value: null);
  }

  static JoiNumberX num() {
    return JoiNumberX(value: null);
  }

  static JoiMapX object(Map<String, JoiX> schema) {
    return JoiMapX(schema, value: null);
  }

  static JoiX ref(String key) {
    return JoiRefX(key: key);
  }

  void required({String? message}) {
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
  }

  @override
  void defaultValue(T value) {
    _compressor.registerValidator(
      JoiValidator(
        options: const ValidatorOptions(priority: JoiValidatorPriority.high),
        identifier: JoiIdentifier.defaultValue,
        nullValidator: () => value,
      ),
    );
  }
  // JoiX valid<S>(List<S> validValues,
  //     {String? message, bool caseSensitive = true});

  JoiResult<T> validate({T? value}) {
    if (value != null) {
      _value = value;
    }
    return _compressor.validate(_value);
  }

  @override
  String toString() {
    return _value.toString();
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

  JoiResult<T> copyWith({
    bool? isSuccess,
    JoiTypeException? error,
    T? value,
  }) {
    return JoiResult<T>(
      isSuccess: isSuccess ?? this._isSuccess,
      error: error ?? this._error,
      value: value ?? this._value,
    );
  }
}
