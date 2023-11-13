import '../error.dart';
import '../identifier.dart';
import '../joix_base.dart';
import '../validator/validator.dart';
import '../validator/validator_compressor.dart';
import 'interfaces/measurable.dart';

class JoiNumberX extends JoiX<num> implements Limitable<num> {
  final num? _value;
  final ValidatorCompressor<num> _compressor;

  JoiNumberX({required num? value, ValidatorCompressor<num>? compressor})
      : _value = value,
        _compressor = compressor ?? ValidatorCompressor<num>();

  @override
  ValidatorCompressor<num> get compressor => _compressor;

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
          throw const JoiTypeException("Must be a positive integer");
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
          throw const JoiTypeException("Must be a negative integer");
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

  @override
  JoiNumberX limit(Integer length, {String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.limit,
      validator: (value) {
        if (value.toString().length != length) {
          throw JoiTypeException(
            message ?? 'Must be exactly $length characters long',
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
