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
  });
}
