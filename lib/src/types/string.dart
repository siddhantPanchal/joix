import 'package:intl/intl.dart';
import 'package:sealed_currencies/sealed_currencies.dart';

import '../error.dart';
import '../identifier.dart';
import '../joix_base.dart';
import '../validator/priority.dart';
import '../validator/validator.dart';
import '../validator/validator_compressor.dart';
import '../validator/validator_options.dart';
import 'interfaces/defaultable.dart';
import 'interfaces/measurable.dart';

final class JoiStringX extends JoiX<String>
    implements Defaultable<String>, Limitable<String> {
  final String? _value;
  final ValidatorCompressor<String> _compressor;

  JoiStringX(ValidatorCompressor<String> compressor, {required String? value})
      : _value = value,
        _compressor = compressor,
        super(compressor);

  JoiStringX notEmpty({String? message}) {
    _compressor.registerValidator(
      JoiValidator(
        identifier: JoiIdentifier.notEmpty,
        beforeValidation: (value) {
          return value.trim();
        },
        validator: (value) {
          if (value.isEmpty) {
            throw JoiTypeException(message ?? "value must not be empty");
          }
        },
        nullValidator: () {
          throw JoiTypeException(message ?? "value must be non null");
        },
      ),
    );

    return this;
  }

  JoiStringX min(int min, {String? message, bool override = true}) {
    _compressor.registerValidator(
      JoiValidator(
        identifier: JoiIdentifier.min,
        options: ValidatorOptions(override: override),
        validator: (value) {
          if (min > value.length) {
            throw JoiTypeException(
                message ?? "value must be minimum $min length long");
          }
        },
      ),
    );
    return this;
  }

  JoiStringX max(int max, {String? message, bool override = true}) {
    _compressor.registerValidator(
      JoiValidator(
        identifier: JoiIdentifier.max,
        options: ValidatorOptions(override: override),
        validator: (value) {
          if (max < value.length) {
            throw JoiTypeException(
              message ?? "value must be maximum $max length long",
            );
          }
        },
      ),
    );
    return this;
  }

  void _match(RegExp regex, String value, String? message) {
    if (!regex.hasMatch(value)) {
      throw JoiTypeException(message ?? "not matched to the custom regex");
    }
  }

  JoiStringX match(RegExp regex, {String? message}) {
    _compressor.registerValidator(
      JoiValidator(
        identifier: JoiIdentifier.match,
        validator: (value) {
          _match(regex, value, message);
        },
      ),
    );
    return this;
  }

  JoiStringX email({String? message}) {
    _compressor.registerValidator(
      JoiValidator(
        identifier: JoiIdentifier.email,
        validator: (value) {
          RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
          _match(regex, value, message ?? "not a valid email address");
        },
      ),
    );
    return this;
  }

  @override
  JoiStringX required({String? message}) {
    _compressor.registerValidator(JoiValidator(
      options: const ValidatorOptions(priority: JoiValidatorPriority.medium),
      identifier: JoiIdentifier.required,
      beforeValidation: (value) {
        return value.trim();
      },
      nullValidator: () {
        throw JoiTypeException(message ?? "value is required");
      },
      validator: (value) {
        if (value.isEmpty) {
          throw JoiTypeException(message ?? "value is required");
        }
      },
    ));
    return this;
  }

  @override
  JoiStringX defaultValue(String value) {
    _compressor.registerValidator(
      JoiValidator(
        options: const ValidatorOptions(priority: JoiValidatorPriority.high),
        identifier: JoiIdentifier.defaultValue,
        nullValidator: () => value,
      ),
    );
    return this;
  }

  JoiStringX base64({bool padding = true, String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.base64,
      validator: (value) {
        RegExp regex = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
        _match(regex, value, message ?? 'Not a valid Base64 string');

        if (padding) {
          if (value.length % 4 != 0 || value.contains(' ')) {
            throw JoiTypeException(message ?? 'Invalid Base64 padding');
          }
        }
      },
    ));
    return this;
  }

  JoiStringX alphanum({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.alphanum,
      validator: (value) {
        _match(
          RegExp(r'^[a-zA-Z0-9]+$'),
          value,
          message ?? 'Not a valid alphanumeric string',
        );
      },
    ));
    return this;
  }

  JoiStringX uri({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.uri,
      validator: (value) {
        try {
          final uri = Uri.parse(value);
          if (!uri.hasScheme) {
            throw JoiTypeException(message ?? 'Not a valid URI Scheme');
          }
        } catch (e) {
          throw JoiTypeException(message ?? 'Not a valid URI');
        }
      },
    ));
    return this;
  }

  @override
  JoiStringX limit(int length, {String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.limit,
      validator: (value) {
        if (value.length != length) {
          throw JoiTypeException(
            message ?? 'Must be exactly $length characters long',
          );
        }
      },
    ));
    return this;
  }

  JoiStringX valid(List<String> validValues,
      {String? message, bool caseSensitive = true}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.valid,
      validator: (value) {
        final comparisonValue = caseSensitive ? value : value.toLowerCase();
        final lowerValidValues = validValues
            .map((v) => caseSensitive ? v : v.toLowerCase())
            .toList();

        if (!lowerValidValues.contains(comparisonValue)) {
          throw JoiTypeException(
              message ?? 'Not one of the valid values: $validValues');
        }
      },
    ));
    return this;
  }

  JoiStringX currencySymbol({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.currencySymbol,
      beforeValidation: (value) {
        return value.trim();
      },
      validator: (value) {
        bool found = false;
        for (var currency in FiatCurrency.list) {
          if (currency.symbol == value) {
            found = true;
            break;
          }
        }
        if (!found) {
          throw JoiTypeException(message ?? 'Not a currency symbol: $value');
        }
      },
    ));
    return this;
  }

  JoiStringX currencyCode({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.currencyCode,
      beforeValidation: (value) => value.trim(),
      validator: (value) {
        bool found = false;
        for (var currency in FiatCurrency.list) {
          if (currency.code.toLowerCase() == value.toLowerCase()) {
            found = true;
            break;
          }
        }
        if (!found) {
          throw JoiTypeException(message ?? 'Not a currency code: $value');
        }
      },
    ));
    return this;
  }

  JoiStringX specialChar({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.specialChar,
      validator: (value) {
        _match(
          RegExp(r'[!@#\$%^&*(),.?":{}|<>]'),
          value,
          message ?? 'String must contain at least one special character',
        );
      },
    ));
    return this;
  }

  JoiStringX creditCard({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.creditCard,
      validator: (value) {
        if (!_isValidCreditCard(value)) {
          throw JoiTypeException(message ?? 'Not a valid credit card number');
        }
      },
    ));
    return this;
  }

  /// uses Luhn algorithm (mod-10)
  bool _isValidCreditCard(String cardNumber) {
    cardNumber = cardNumber.replaceAll(RegExp(r'\D'), ''); // Remove non-digits

    int sum = 0;
    bool isAlternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (isAlternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      isAlternate = !isAlternate;
    }

    return sum % 10 == 0;
  }

  JoiStringX num({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.num,
      validator: (value) {
        _match(
          RegExp(r'\d'),
          value,
          message ?? 'String must contain at least one digit',
        );
      },
    ));
    return this;
  }

  JoiStringX date(String format, {String? message}) {
    _compressor.registerValidator(
      JoiValidator(
        identifier: JoiIdentifier.date,
        validator: (value) {
          try {
            DateFormat(format).parseStrict(value);
          } on FormatException catch (e) {
            throw JoiTypeException(e.message);
          }
        },
      ),
    );
    return this;
  }

  JoiStringX countryCode({String? message}) {
    _compressor.registerValidator(
      JoiValidator(
        identifier: JoiIdentifier.countryCode,
        validator: (value) {
          message ??= 'Not a valid ISO 3166-1 alpha-2 code';
          if (value.length > 2) {
            throw JoiTypeException(message!);
          }
          _match(
            RegExp(
                r'^A[^ABCHJKNPVY]|B[^CKPUX]|C[^BEJPQST]|D[EJKMOZ]|E[CEGHRST]|F[IJKMOR]|G[^CJKOVXZ]|H[KMNRTU]|I[DEL-OQ-T]|J[EMOP]|K[EGHIMNPRWYZ]|L[ABCIKR-VY]|M[^BIJ]|N[ACEFGILOPRUZ]|OM|P[^BCDIJOPQUVXZ]|QA|R[EOSUW]|S[^FPQUW]|T[^ABEIPQSUXY]|U[AGMSYZ]|V[ACEGINU]|WF|WS|YE|YT|Z[AMW]+$'),
            value,
            message,
          );
        },
      ),
    );
    return this;
  }

  JoiStringX custom(JoiValidator<String> validator) {
    _compressor.registerValidator(validator);
    return this;
  }

  JoiStringX password({int minLen = 8, int? maxLen}) {
    min(minLen, message: "password is not strong enough", override: false);
    if (maxLen != null) {
      max(maxLen, message: "password is too long", override: false);
    }
    specialChar(
      message: "password should have at least one special character",
    );
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.password,
      validator: (value) {
        _match(
          RegExp(r'[A-Z]+'),
          value,
          "password should have at least one uppercase letter",
        );
        _match(
          RegExp(r'[a-z]+'),
          value,
          "password should have at least one lowercase letter",
        );
        _match(
          RegExp(r'[0-9]+'),
          value,
          "password should have at least one digit",
        );
      },
    ));
    return this;
  }

  JoiStringX image({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: "image",
      beforeValidation: (value) => value.trim(),
      validator: (value) {
        _match(
          RegExp(
              r'^[a-zA-Z0-9_\-]+\.(jpg|jpeg|png|gif|bmp|svg|tiff|tif|webp|raw)$'),
          value,
          message ?? "not valid image",
        );
      },
    ));
    return this;
  }

  JoiStringX start(String str, {String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.start,
      beforeValidation: (value) => value.trim(),
      validator: (value) {
        if (!value.startsWith(str)) {
          throw JoiTypeException("value does not start with $str");
        }
      },
    ));
    return this;
  }

  JoiStringX end(String str, {String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.end,
      beforeValidation: (value) => value.trim(),
      validator: (value) {
        if (!value.endsWith(str)) {
          throw JoiTypeException("value does not end with $str");
        }
      },
    ));
    return this;
  }

  @override
  String? get value => _value;
}
