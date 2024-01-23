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

  void int({String? message}) {
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
  }

  void positive({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.positive,
      validator: (value) {
        if (value < 0) {
          throw JoiTypeException(message ?? "Must be a positive integer");
        }
      },
    ));
  }

  void negative({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.negative,
      validator: (value) {
        if (value > 0) {
          throw JoiTypeException(message ?? "Must be a negative integer");
        }
      },
    ));
  }

  void decimal({String? message}) {
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
  }

  void double({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.double,
      validator: (value) {
        if (value is! Double) {
          throw JoiTypeException("Must be a valid double number");
        }
      },
    ));
  }

  void divisible(num by, {String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.divisible,
      validator: (value) {
        if (value.remainder(by) != 0) {
          throw JoiTypeException(message ?? "value is not divisible by $by");
        }
      },
    ));
  }

  void min(num number, {String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.divisible,
      validator: (value) {
        if (value < number) {
          throw JoiTypeException(message ?? "value must be less than $number");
        }
      },
    ));
  }

  void max(num number, {String? message}) {
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
  }

  void _match(RegExp pattern, String value, String errorMessage) {
    if (!pattern.hasMatch(value)) {
      throw JoiTypeException(errorMessage);
    }
  }

}
