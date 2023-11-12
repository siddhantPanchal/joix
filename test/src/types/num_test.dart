import 'package:joix/joix.dart';
import 'package:test/test.dart';

import '../../helper.dart';

void main() {
  group("JoiNumberX", () {
    group('JoiNumberX int Validation', () {
      test(
        'When valid integer value is given, validation must pass',
        () {
          // arrange
          final joiNumber = 42.joi();

          // act
          final result = joiNumber.int().validate();

          // assert
          checkForPass(result);
        },
      );

      test(
        'When valid negative integer value is given, validation must pass',
        () {
          // arrange
          final joiNumber = (-15).joi();

          // act
          final result = joiNumber.int().validate();

          // assert
          checkForPass(result);
        },
      );

      test(
        'When valid positive integer value is given, validation must pass',
        () {
          // arrange
          final joiNumber = 123.joi();

          // act
          final result = joiNumber.int().validate();

          // assert
          checkForPass(result);
        },
      );

      test(
        'When invalid decimal value is given, validation must fail',
        () {
          // arrange
          final joiNumber = 42.5.joi();

          // act
          final result = joiNumber.int().validate();

          // assert
          checkForFail(result, "Must be a valid integer");
        },
      );

      test(
        'When null value is given, validation must fail',
        () {
          // arrange
          final joiNumber = <String, num?>{}[""].joi();

          // act
          final result = joiNumber.int().required().validate();

          // assert
          checkForFail(result, 'value is required');
        },
      );
    });

    group('JoiNumberX positive Validation', () {
      test(
        'When valid positive integer value is given, validation must pass',
        () {
          // arrange
          final joiNumber = 42.joi();

          // act
          final result = joiNumber.positive().validate();

          // assert
          checkForPass(result);
        },
      );

      test(
        'When valid positive decimal value is given, validation must pass',
        () {
          // arrange
          final joiNumber = 123.45.joi();

          // act
          final result = joiNumber.positive().validate();

          // assert
          checkForPass(result);
        },
      );

      test(
        'When invalid negative integer value is given, validation must fail',
        () {
          // arrange
          final joiNumber = (-15).joi();

          // act
          final result = joiNumber.positive().validate();

          // assert
          checkForFail(result, 'Must be a positive integer');
        },
      );

      test(
        'When null value is given, validation must fail',
        () {
          // arrange
          final joiNumber = <String, num?>{}[""].joi();

          // act
          final result = joiNumber.positive().required().validate();

          // assert
          checkForFail(result, 'value is required');
        },
      );
    });

    group('JoiNumberX negative Validation', () {
      test(
        'When valid negative integer value is given, validation must pass',
        () {
          // arrange
          final joiNumber = (-42).joi();

          // act
          final result = joiNumber.negative().validate();

          // assert
          checkForPass(result);
        },
      );

      test(
        'When valid negative decimal value is given, validation must pass',
        () {
          // arrange
          final joiNumber = (-123.45).joi();

          // act
          final result = joiNumber.negative().validate();

          // assert
          checkForPass(result);
        },
      );

      test(
        'When invalid positive integer value is given, validation must fail',
        () {
          // arrange
          final joiNumber = 15.joi();

          // act
          final result = joiNumber.negative().validate();

          // assert
          checkForFail(result, 'Must be a negative integer');
        },
      );
    });

    group('JoiNumberX decimal Validation', () {
      test(
        'Passes when valid positive integer value is given',
        () {
          // arrange
          final joiNumber = 42.joi();

          // act
          final result = joiNumber.decimal().validate();

          // assert
          checkForPass(result);
        },
      );

      test(
        'Passes when valid positive decimal value is given',
        () {
          // arrange
          final joiNumber = 123.45.joi();

          // act
          final result = joiNumber.decimal().validate();

          // assert
          checkForPass(result);
        },
      );

      test(
        'Passes when valid negative decimal value is given',
        () {
          // arrange
          final joiNumber = (-123.45).joi();

          // act
          final result = joiNumber.decimal().validate();

          // assert
          checkForPass(result);
        },
      );
    });

    group('JoiNumberX limit Validation', () {
      test(
        'Passes when value length matches the specified limit',
        () {
          // arrange
          final joiNumber = 12345.joi();

          // act
          final result = joiNumber.limit(5).validate();

          // assert
          checkForPass(result);
        },
      );

      test(
        'Fails when value length does not match the specified limit',
        () {
          // arrange
          final joiNumber = 987654321.joi();

          // act
          final result = joiNumber.limit(5).validate();

          // assert
          checkForFail(result, 'Must be exactly 5 characters long');
        },
      );
    });
  });
}
