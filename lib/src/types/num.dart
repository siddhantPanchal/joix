import 'package:joix/joix.dart';

import '../validator/validator.dart';
import '../validator/validator_compressor.dart';

class JoiNumberX extends JoiX<num> {
  final num? _value;
  final ValidatorCompressor<num> _compressor;

  JoiNumberX(ValidatorCompressor<num> compressor,
      {required num? value})
      : _value = value,
        _compressor = compressor,
        super(compressor);

  @override
  num? get value => _value;

  JoiNumberX int({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.int,
      validator: (value) {
        _match(
          RegExp(r'^-?\d+$'),
          value.toString(),
          message ?? 'Must be a valid integer',
        );
      },
    ));
    return this;
  }

  JoiNumberX positive({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.positive,
      validator: (value) {
        if (value < 0) {
          throw JoiTypeException(message ?? "Must be a positive integer");
        }
      },
    ));
    return this;
  }

  JoiNumberX negative({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.negative,
      validator: (value) {
        if (value > 0) {
          throw JoiTypeException(message ?? "Must be a negative integer");
        }
      },
    ));
    return this;
  }

  JoiNumberX decimal({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.decimal,
      validator: (value) {
        _match(
          RegExp(r'^-?\d+(\.\d+)?$'),
          value.toString(),
          message ?? 'Must be a valid decimal number',
        );
      },
    ));
    return this;
  }

  JoiNumberX double({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.double,
      validator: (value) {
        if (value is! Double) {
          throw JoiTypeException("Must be a valid double number");
        }
      },
    ));
    return this;
  }

  JoiNumberX divisible(num by, {String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.divisible,
      validator: (value) {
        if (value.remainder(by) != 0) {
          throw JoiTypeException(message ?? "value is not divisible by $by");
        }
      },
    ));
    return this;
  }

  JoiNumberX min(num number, {String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.divisible,
      validator: (value) {
        if (value < number) {
          throw JoiTypeException(message ?? "value must be less than $number");
        }
      },
    ));
    return this;
  }

  JoiNumberX max(num number, {String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.divisible,
      validator: (value) {
        if (value > number) {
          throw JoiTypeException(
            message ?? "value must be greater than $number",
          );
        }
      },
    ));
    return this;
  }

  void _match(RegExp pattern, String value, String errorMessage) {
    if (!pattern.hasMatch(value)) {
      throw JoiTypeException(errorMessage);
    }
  }

}
