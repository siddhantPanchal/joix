import 'package:joix/joix.dart';
import 'package:test/test.dart';

import '../../helper.dart';

void main() {
  group("Test JoiStringX class", () {
    group("JoiStringX notEmpty validation", () {
      test(
          "when not empty string value is provided, then validation must success",
          () {
        // arrange
        final joiString = ("hello world").joi();

        // act
        final result = joiString..notEmpty();

        // assert
        checkForPass(result.validate());
      });

      test(
          "when empty string value is provided, then validation must failed and throws JoiTypeException",
          () {
        // arrange
        final joiString = ("").joi();

        // // act
        final result = joiString..notEmpty();

        // assert
        checkForFail(result.validate(), "value must not be empty");
      });

      test(
          "when not - empty string (with whitespace) value is provided, then validation success",
          () {
        // arrange
        final joiString = " ".joi();

        // // act
        final result = joiString..notEmpty();

        // assert
        checkForFail(result.validate(), "value must not be empty");
      });
    });

    group("JoiStringX min validation", () {
      test(
          "when string value and valid min length is provided, then validation must success",
          () {
        // arrange
        final joiString = "hello world".joi();

        // act
        final result = joiString..min(4);

        // assert
        checkForPass(result.validate());
      });

      test(
          "when string value and invalid min length is provided, then validation must failed and throws JoiTypeException",
          () {
        // arrange
        final joiString = "hello".joi();

        // act
        final result = joiString..min(8);

        // assert
        checkForFail(result.validate(), "value must be minimum 8 length long");
      });
    });

    group("JoiStringX max validation", () {
      test(
          "when string value and valid max length is provided, then validation must success",
          () {
        // arrange
        final joiString = "hello world".joi();

        // act
        final result = joiString..max(11);

        // assert
        checkForPass(result.validate());
      });

      test(
          "when string value and invalid min length is provided, then validation must failed and throws JoiTypeException",
          () {
        // arrange
        final joiString = "hello".joi();

        // act
        final result = joiString..max(4);

        // assert
        checkForFail(result.validate(), "value must be maximum 4 length long");
      });
    });

    group("JoiStringX match validation", () {
      // Regular expression pattern to check if both 'E' and 'K' are present
      final sampleRegex = RegExp(r'E.*K|K.*E');

      test(
          "when string value and valid regex is provided, then validation must success",
          () {
        // arrange
        final joiString = "hEllo K world".joi();

        // act
        final result = joiString..match(sampleRegex);

        // assert
        checkForPass(result.validate());
      });

      test(
          "when string value and invalid min length is provided, then validation must failed and throws JoiTypeException",
          () {
        // arrange
        final joiString = "hello K".joi();

        // act
        final result = joiString..match(sampleRegex);

        // assert
        checkForFail(result.validate(), "not matched to the custom regex");
      });
    });

    group("JoiStringX email validation", () {
      test(
          "when valid email value and valid regex is provided, then validation must success",
          () {
        // arrange
        final joiString = "example@gmail.com".joi();

        // act
        final result = joiString..email();

        // assert
        checkForPass(result.validate());
      });

      test(
          "when valid email(with _) value and valid regex is provided, then validation must success",
          () {
        // arrange
        final joiString = "user_name@example.com".joi();

        // act
        final result = joiString..email();

        // assert
        checkForPass(result.validate());
      });

      test(
          "when valid email(with -) value and valid regex is provided, then validation must success",
          () {
        // arrange
        final joiString = "user-name@example.com".joi();

        // act
        final result = joiString..email();

        // assert
        checkForPass(result.validate());
      });

      test(
          "when invalid email value and invalid min length is provided, then validation must failed and throws JoiTypeException",
          () {
        // arrange
        final joiString = "hello K.com".joi();

        // act
        final result = joiString..email();

        // assert
        checkForFail(result.validate(), "not a valid email address");
      });
      test(
          "when invalid email (empty) value and invalid min length is provided, then validation must failed and throws JoiTypeException",
          () {
        // arrange
        final joiString = "".joi();

        // act
        final result = joiString
          ..email()
          ..required(message: "email is required");

        // assert
        checkForFail(result.validate(), "email is required");
      });
    });

    group("JoiStringX required validation", () {
      test(
          "when non null empty string value is given then validation must fail",
          () {
        // arrange
        final joiString = "".joi();

        // act
        final result = joiString..required(message: 'value is required');

        // assert
        checkForFail(result.validate(), "value is required");
      });

      test(
          "when non null but with whitespace string value is given then validation must fail",
          () {
        // arrange
        final joiString = " ".joi();

        // act
        final result = joiString..required(message: 'value is required');

        // assert
        checkForFail(result.validate(), "value is required");
      });

      test(
          "when non null valid string value is given then validation must pass",
          () {
        // arrange
        final joiString = "some string".joi();

        // act
        final result = joiString..required();

        // assert
        checkForPass(result.validate());
      });

      test(
          "when invalid string (min length 8, max length 10, required ) value is given then validation must fail",
          () {
        // arrange
        final joiString = "some string".joi();

        // act
        final result = joiString
          ..min(8)
          ..max(10)
          ..required();

        // assert
        checkForFail(result.validate(), "value must be maximum 10 length long");
      });

      test(
          "when valid string (min length 8, max length 10, required ) value is given then validation must pass",
          () {
        // arrange
        final joiString = "someString".joi();

        // act
        final result = joiString
          ..min(8)
          ..max(10)
          ..required();

        // assert
        checkForPass(result.validate());
      });

      test("when null string value is given then validation must fail", () {
        // arrange
        // ignore: unnecessary_cast
        final joiString = (null as String?).joi();

        // act
        final result = joiString..required(message: 'value is required');

        // assert
        checkForFail(result.validate(), "value is required");
      });
    });

    group("JoiStringX defaultValue validation ", () {
      test(
          "when validation applied on null value with defaultValue('some value') then validation should success",
          () {
        // arrange
        final map = <String, String?>{};
        final joiString = (map[""]).joi();

        // act
        final result = joiString..defaultValue("some value");

        checkForPass(result.validate());
      });

      test(
          "when validation applied on 'some value' with defaultValue('new value') then validation should success and value should be 'some value' (old one)",
          () {
        // arrange
        final joiString = "some value".joi();

        // act
        final result = joiString
          ..defaultValue("new value")
          ..required();

        checkForPass(result.validate());
        expect(result.value, "some value");
      });
    });

    group('JoiStringX base64 validation', () {
      test('Valid Base64 String', () {
        // arrange
        final joiString = "SGVsbG8gd29ybGQ=".joi();

        // act
        final result = joiString..base64();

        // assert
        checkForPass(result.validate());
      });

      test('Invalid Base64 String (Contains Invalid Characters)', () {
        // arrange
        final joiString = "SGVsbG8gd29ybGQ=@".joi();

        // act
        final result = joiString..base64();

        // assert
        checkForFail(result.validate(), "Not a valid Base64 string");
      });

      test('Invalid Base64 String (Incomplete Padding)', () {
        // arrange
        final joiString = "SGVsbG8gd29ybGQ".joi();

        // act
        final result = joiString..base64();

        // assert
        checkForFail(result.validate(), "Invalid Base64 padding");
      });

      test('Valid Base64 String (With Optional Padding)', () {
        // arrange
        final joiString = "SGVsbG8gd29ybGQ".joi();

        // act
        final result = joiString..base64();

        // assert
        checkForFail(result.validate(), "Invalid Base64 padding");
      });
    });

    group('JoiStringX alphanum validation', () {
      test('Valid Alphanumeric String', () {
        // arrange
        final joiString = "abc123".joi();

        // act
        final result = joiString..alphanum();

        // assert
        checkForPass(result.validate());
      });

      test('Valid Alphanumeric String with Uppercase Letters', () {
        // arrange
        final joiString = "ABC123".joi();

        // act
        final result = joiString..alphanum();

        // assert
        checkForPass(result.validate());
      });

      test('Invalid Alphanumeric String (Contains Special Characters)', () {
        // arrange
        final joiString = "abc@123".joi();

        // act
        final result = joiString..alphanum();

        // assert
        checkForFail(result.validate(), "Not a valid alphanumeric string");
      });

      test('Invalid Alphanumeric String (Contains Spaces)', () {
        // arrange
        final joiString = "abc 123".joi();

        // act
        final result = joiString..alphanum();

        // assert
        checkForFail(result.validate(), "Not a valid alphanumeric string");
      });

      test('Invalid Alphanumeric String (Empty String)', () {
        // arrange
        final joiString = "".joi();

        // act
        final result = joiString
          ..alphanum()
          ..required(message: "string is empty");

        // assert
        checkForFail(result.validate(), "string is empty");
      });
    });

    group('JoiStringX uri validation', () {
      test('Valid URI', () {
        // arrange
        final joiString = "https://example.com".joi();

        // act
        final result = joiString..uri();

        // assert
        checkForPass(result.validate());
      });

      test('Valid URI (With Query Parameters)', () {
        // arrange
        final joiString = "https://example.com/path?param=value".joi();

        // act
        final result = joiString..uri();

        // assert
        checkForPass(result.validate());
      });

      test('Invalid URI (Malformed)', () {
        // arrange
        final joiString = "not_a_uri".joi();

        // act
        final result = joiString..uri();

        // assert
        checkForFail(result.validate(), "Not a valid URI");
      });

      test('Invalid URI (Empty String)', () {
        // arrange
        final joiString = "".joi();

        // act
        final result = joiString
          ..uri()
          ..required(message: "empty url");

        // assert
        checkForFail(result.validate(), "empty url");
      });

      test('Invalid URI (Missing Scheme)', () {
        // arrange
        final joiString = "google.com".joi();

        // act
        final result = joiString..uri();

        // assert
        checkForFail(result.validate(), "Not a valid URI");
      });
    });

    group('JoiStringX exactLength validation', () {
      test('Valid String Length', () {
        // arrange
        final joiString = "abcdefgh".joi();

        // act
        final result = joiString..limit(8);

        // assert
        checkForPass(result.validate());
      });

      test('Invalid String Length (Too Short)', () {
        // arrange
        final joiString = "abc".joi();

        // act
        final result = joiString..limit(8);

        // assert
        checkForFail(result.validate(), "Must be exactly 8 characters long");
      });

      test('Invalid String Length (Too Long)', () {
        // arrange
        final joiString = "abcdefghi".joi();

        // act
        final result = joiString..limit(8);

        // assert
        checkForFail(result.validate(), "Must be exactly 8 characters long");
      });

      test('Invalid String Length (Empty String)', () {
        // arrange
        final joiString = "".joi();

        // act
        final result = joiString
          ..notEmpty(message: "Must be exactly 8 characters long")
          ..limit(8);

        // assert
        checkForFail(result.validate(), "Must be exactly 8 characters long");
      });

      test('Invalid String Length (Null)', () {
        // arrange
        final map = <String, dynamic>{};
        final joiString = (map[""] as String?).joi();

        // act
        final result = joiString
          ..limit(8)
          ..required(message: 'value is required');

        // assert
        checkForFail(result.validate(), "value is required");
      });
      test('Invalid String Length (Null)', () {
        // arrange
        final map = <String, dynamic>{};
        final joiString = (map[""] as String?).joi();

        // act
        final result = joiString..limit(8);

        // assert
        checkForPass(result.validate());
      });
    });

    group('JoiStringX validValues validation', () {
      // Case-Sensitive Validation
      test('Case-Sensitive Validation - Valid Value', () {
        // arrange
        final joiString = "apple".joi();

        // act
        final result = joiString..valid(["apple", "banana", "orange"]);

        // assert
        checkForPass(result.validate());
      });

      test('Case-Sensitive Validation - Invalid Value', () {
        // arrange
        final joiString = "Apple".joi();
        final validValues = ["apple", "banana", "orange"];

        // act
        final result = joiString..valid(validValues);

        // assert
        checkForFail(
            result.validate(), "Not one of the valid values: $validValues");
      });

      // Case-Insensitive Validation
      test('Case-Insensitive Validation - Valid Value', () {
        // arrange
        final joiString = "Apple".joi();

        // act
        final result = joiString
          ..valid(["apple", "banana", "orange"], caseSensitive: false);

        // assert
        checkForPass(result.validate());
      });
      // Case-Insensitive Validation
      test('Case-Insensitive Validation - Valid Value', () {
        // arrange
        final joiString = "apple".joi();

        // act
        final result = joiString
          ..valid(["apple", "banana", "orange"], caseSensitive: false);

        // assert
        checkForPass(result.validate());
      });

      test('Case-Insensitive Validation - Invalid Value', () {
        // arrange
        final joiString = "Pear".joi();
        final validValues = ["apple", "banana", "orange"];

        // act
        final result = joiString..valid(validValues, caseSensitive: false);

        // assert
        checkForFail(
            result.validate(), "Not one of the valid values: $validValues");
      });
    });

    group('JoiStringX currencyCode validation', () {
      test('Valid Currency Code', () {
        // arrange
        final joiString = "USD".joi();
        final joiString1 = "inr".joi();

        // act
        final result = joiString..currencyCode();
        final result1 = joiString1..currencyCode();

        // assert
        checkForPass(result.validate());
        checkForPass(result1.validate());
      });

      test('Invalid Currency Code', () {
        // arrange
        final joiString = "Rs".joi(); // valid INR

        // act
        final result = joiString..currencyCode();

        // assert
        checkForFail(result.validate(), "Not a currency code: Rs");
      });
    });

    group('JoiStringX specialChar validation', () {
      test('String with Special Character', () {
        // arrange
        final joiString = "Hello@World".joi();

        // act
        final result = joiString..specialChar();

        // assert
        checkForPass(result.validate());
      });

      test('String without Special Character', () {
        // arrange
        final joiString = "HelloWorld".joi();

        // act
        final result = joiString..specialChar();

        // assert
        checkForFail(result.validate(),
            "String must contain at least one special character");
      });

      test('String with Special Character (Whitespace)', () {
        // arrange
        final joiString = "Hello @ World".joi();

        // act
        final result = joiString..specialChar();

        // assert
        checkForPass(result.validate());
      });

      test('String with only Special Character (Whitespace)', () {
        // arrange
        final joiString = " ".joi();

        // act
        final result = joiString
          ..required(
              message: "String must contain at least one special character")
          ..specialChar();

        // assert
        checkForFail(result.validate(),
            "String must contain at least one special character");
      });

      test('String with only Special Character (Whitespace)', () {
        // arrange
        final joiString = "€".joi();

        // act
        final result = joiString..specialChar();

        // assert
        checkForFail(
          result.validate(),
          "String must contain at least one special character",
        );
      });
    });

    group('JoiStringX creditCard validation', () {
      test('Valid Credit Card Number (Visa)', () {
        // arrange
        final joiString = "4111111111111111".joi(); // Visa test number

        // act
        final result = joiString..creditCard();

        // assert
        checkForPass(result.validate());
      });

      test('Invalid Credit Card Number (Luhn Check Failed)', () {
        // arrange
        // Visa test number with modified last digit
        final joiString = "4111111111111112".joi();

        // act
        final result = joiString..creditCard();

        // assert
        checkForFail(result.validate(), 'Not a valid credit card number');
      });

      test('Invalid Credit Card Number (Non-Digit Characters)', () {
        // arrange
        // Visa test number with dashes
        final joiString = "4111-1111-1111-1111".joi();

        // act
        final result = joiString..creditCard();

        // assert
        checkForPass(result.validate());
      });
    });

    group('JoiStringX num validation', () {
      test('String with Number', () {
        // arrange
        final joiString = "Hello123World".joi();

        // act
        final result = joiString..num();

        // assert
        checkForPass(result.validate());
      });

      test('String without Number', () {
        // arrange
        final joiString = "HelloWorld".joi();

        // act
        final result = joiString..num();

        // assert
        checkForFail(
            result.validate(), 'String must contain at least one digit');
      });

      test('String with Number (Whitespace)', () {
        // arrange
        final joiString = "Hello 123 World".joi();

        // act
        final result = joiString..num();

        // assert
        checkForPass(result.validate());
      });
    });

    group('JoiStringX date validation', () {
      test(
        'Matching Format, Valid Date Time',
        () {
          // arrange
          final joiString = "2023-11-10 12:34:56".joi();

          // act
          final result = joiString..date('yyyy-MM-dd HH:mm:ss');

          // assert
          checkForPass(result.validate());
        },
      );

      test(
        'Matching Format, Invalid Date Time',
        () {
          // arrange
          final joiString = "2023-11-10 NotATime".joi();

          // act
          final result = joiString..date('yyyy-MM-dd HH:mm:ss');

          // assert
          checkForFail(result.validate(),
              'Trying to read HH from 2023-11-10 NotATime at 11');
        },
      );

      test(
        'Non-Matching Format, Valid Date Time',
        () {
          // arrange
          final joiString = "2023/11/10 12:34:56".joi();

          // act
          final result = joiString..date('yyyy-MM-dd HH:mm:ss');

          // assert
          checkForFail(result.validate(),
              'Trying to read - from 2023/11/10 12:34:56 at 5');
        },
      );

      test(
        'Non-Matching Format, Invalid Date Time',
        () {
          // arrange
          final joiString = "NotADate NotATime".joi();

          // act
          final result = joiString..date('yyyy-MM-dd HH:mm:ss');

          // assert
          checkForFail(result.validate(),
              'Trying to read yyyy from NotADate NotATime at 0');
        },
      );
    });

    group('JoiStringX iso3166Alpha2 validation', () {
      test(
        'Valid ISO 3166-1 alpha-2 code should pass validation',
        () {
          final joiString = "US".joi();
          final result = joiString..countryCode();
          checkForPass(result.validate());
        },
      );

      test(
        'Invalid ISO 3166-1 alpha-2 code (length > 2) should fail validation',
        () {
          final joiString = "USA".joi();
          final result = joiString..countryCode();
          checkForFail(
              result.validate(), 'Not a valid ISO 3166-1 alpha-2 code');
        },
      );

      test(
        'Invalid ISO 3166-1 alpha-2 code (non-alphabetic characters) should fail validation',
        () {
          final joiString = "U1".joi();
          final result = joiString..countryCode();
          checkForFail(
              result.validate(), "Not a valid ISO 3166-1 alpha-2 code");
        },
      );
    });

    group('JoiStringX password validation', () {
      test('Valid password within length range should pass validation', () {
        // Arrange
        final joiString = "StrongPassword123!".joi();

        // Act
        final result = joiString..password(minLen: 8, maxLen: 20);

        // Assert
        checkForPass(result.validate());
      });

      test('Password less than minimum length should fail validation', () {
        // Arrange
        final joiString = "WeakPwd".joi();

        // Act
        final result = joiString..password(minLen: 8, maxLen: 20);

        // Assert
        checkForFail(result.validate(), "password is not strong enough");
      });

      test('Password exceeding maximum length should fail validation', () {
        // Arrange
        final joiString = "VeryLongPassword1234567890".joi();

        // Act
        final result = joiString..password(minLen: 8, maxLen: 20);

        // Assert
        checkForFail(result.validate(), "password is too long");
      });

      test('Password missing uppercase letter should fail validation', () {
        // Arrange
        final joiString = "weak_password123!".joi();

        // Act
        final result = joiString..password(minLen: 8, maxLen: 20);

        // Assert
        checkForFail(result.validate(),
            "password should have at least one uppercase letter");
      });
    });

    group('JoiStringX image validation', () {
      test('Valid image filename should pass validation', () {
        // Arrange
        final joiString = "example_image.jpg".joi();

        // Act
        final result = joiString..image();

        // Assert
        checkForPass(result.validate());
      });

      test('Invalid image filename extension should fail validation', () {
        // Arrange
        final joiString = "example_document.pdf".joi();

        // Act
        final result = joiString..image();

        // Assert
        checkForFail(result.validate(), 'not valid image');
      });

      test('Whitespace-trimmed valid image filename should pass validation',
          () {
        // Arrange
        final joiString = "   example_image.jpg   ".joi();

        // Act
        final result = joiString..image();

        // Assert
        checkForPass(result.validate());
      });
    });

    group('JoiStringX start Validation', () {
      test(
        'When valid string starting with "prefix" is given, validation must pass',
        () {
          // arrange
          final joiString = 'prefix_someString'.joi();

          // act
          final result = joiString..start('prefix');

          // assert
          checkForPass(result.validate());
        },
      );

      test(
        'When valid string starting with "123" is given, validation must pass',
        () {
          // arrange
          final joiString = '12345'.joi();

          // act
          final result = joiString..start('123');

          // assert
          checkForPass(result.validate());
        },
      );

      test(
        'When invalid string is given, validation must fail',
        () {
          // arrange
          final joiString = 'someString'.joi();

          // act
          final result = joiString..start('prefix');

          // assert
          checkForFail(result.validate(), 'value does not start with prefix');
        },
      );
    });

    group('JoiStringX end Validation', () {
      test(
        'When valid string starting with "suffix" is given, validation must pass',
        () {
          // arrange
          final joiString = 'someString_suffix'.joi();

          // act
          final result = joiString..end('suffix');

          // assert
          checkForPass(result.validate());
        },
      );

      test(
        'When valid string starting with "45" is given, validation must pass',
        () {
          // arrange
          final joiString = '12345'.joi();

          // act
          final result = joiString..end('45');

          // assert
          checkForPass(result.validate());
        },
      );

      test(
        'When invalid string is given, validation must fail',
        () {
          // arrange
          final joiString = 'someString'.joi();

          // act
          final result = joiString..end('suffix');

          // assert
          checkForFail(result.validate(), 'value does not end with suffix');
        },
      );
    });

    group("JoiStringX invalid validation", () {
      test("when given value is not from given list, validation must pass", () {
        final joiString = "string".joi();

        final result = joiString..invalid(["int", "double", "float", "bigint"]);

        checkForPass(result.validate());
      });
      test(
          "when given value(lowercase) is from given list(uppercase), case insensitive validation must fail",
          () {
        var s = "string";
        final joiString = s.joi();

        final result = joiString
          ..invalid(["int", "double", "float", "String"], caseSensitive: false);

        checkForFail(result.validate(), "$s is not valid value");
      });
      test(
          "when given value(lowercase) is from given list(uppercase), case sensitive validation must pass",
          () {
        var s = "string";
        final joiString = s.joi();

        final result = joiString
          ..invalid(
            ["int", "double", "float", "String"],
            caseSensitive: true,
          );

        checkForPass(result.validate());
      });
    });
  });
}
