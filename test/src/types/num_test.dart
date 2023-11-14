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

    group('JoiNumberX double Validation', () {
      test("Valid double number", () {
        // arrange
        final joiNumber = 42.5.joi();

        // act
        final result = joiNumber.double().validate();

        // assert
        checkForPass(result);
      });
      test("negative double number", () {
        // arrange
        final joiNumber = (-42.5).joi();

        // act
        final result = joiNumber.double().validate();

        // assert
        checkForPass(result);
      });
      test("invalid double number", () {
        // arrange
        final joiNumber = 42.joi();

        // act
        final result = joiNumber.double().validate();

        // assert
        checkForFail(result, "Must be a valid double number");
      });
    });

    group("JoiNumberX divisible validation", () {
      test("given valid int number, then validation must pass", () {
        final joiNumber = 42.joi();

        final result = joiNumber.divisible(2).validate();

        checkForPass(result);
      });
      test(
          "given valid int number but not divisible number, then validation must fail",
          () {
        final joiNumber = 42.joi();

        var by = 4;
        final result = joiNumber.divisible(by).validate();

        checkForFail(result, "value is not divisible by $by");
      });
      test(
          "given double number but divisible int number, then validation must pass",
          () {
        final joiNumber = 42.0.joi();

        var by = 3;
        final result = joiNumber.divisible(by).validate();

        checkForPass(result);
      });
      test(
          "given double number but not divisible double number, then validation must pass",
          () {
        final joiNumber = 42.1.joi();

        var by = 3.0;
        final result = joiNumber.divisible(by).validate();

        checkForFail(result, "value is not divisible by $by");
      });
    });

    group("JoiNumber min validation", () {
      test(
          "given number in greater that specified min number, validation should pass",
          () {
        final joiNumber = 42.1.joi();
        final min = 40;

        final result = joiNumber.min(min).validate();

        checkForPass(result);
      });
      test(
          "given number in less that specified min number, validation should fail",
          () {
        final joiNumber = 42.1.joi();
        final min = 50;

        final result = joiNumber.min(min).validate();

        checkForFail(result, "value must be less than $min");
      });
      test("given number is equal to min number, validation should pass", () {
        final joiNumber = 42.0.joi();
        final min = 42;

        final result = joiNumber.min(min).validate();

        checkForPass(result);
      });
    });

    group("JoiNumber max validation", () {
      test(
          "given number in less that specified max number, validation should pass",
          () {
        final joiNumber = 42.1.joi();
        final max = 50;

        final result = joiNumber.max(max).validate();

        checkForPass(result);
      });
      test(
          "given number in greater that specified max number, validation should fail",
          () {
        final joiNumber = 42.1.joi();
        final max = 40;

        final result = joiNumber.max(max).validate();

        checkForFail(result, "value must be greater than $max");
      });
      test("given number is equal to max number, validation should pass", () {
        final joiNumber = 42.0.joi();
        final max = 42;

        final result = joiNumber.max(max).validate();

        checkForPass(result);
      });
    });
  });
}
