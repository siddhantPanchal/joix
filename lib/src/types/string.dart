part of "../joix_base.dart";

final class JoiStringX
    with JoiX<String>
    implements Defaultable<String>, Limitable<String> {
  JoiStringX({required String? value}) {
    _value = value;
    _compressor = ValidatorCompressor<String>();
  }

  void notEmpty({String? message}) {
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
  }

  void min(int min, {String? message, bool override = true}) {
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
  }

  void max(int max, {String? message, bool override = true}) {
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
  }

  void _match(RegExp regex, String value, String? message) {
    if (!regex.hasMatch(value)) {
      throw JoiTypeException(message ?? "not matched to the custom regex");
    }
  }

  void match(RegExp regex, {String? message}) {
    _compressor.registerValidator(
      JoiValidator(
        identifier: JoiIdentifier.match,
        validator: (value) {
          _match(regex, value, message);
        },
      ),
    );
  }

  void email({String? message}) {
    _compressor.registerValidator(
      JoiValidator(
        identifier: JoiIdentifier.email,
        validator: (value) {
          RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
          _match(regex, value, message ?? "not a valid email address");
        },
      ),
    );
  }

  @override
  void required({String? message}) {
    _compressor.registerValidator(JoiValidator(
      options: const ValidatorOptions(priority: JoiValidatorPriority.medium),
      identifier: JoiIdentifier.required,
      beforeValidation: (value) {
        return value.trim();
      },
      nullValidator: () {
        throw JoiTypeException(
          message ?? "The $name is required. Please provide a valid value.",
        );
      },
      validator: (value) {
        if (value.isEmpty) {
          throw JoiTypeException(
            message ?? "The $name cannot be empty. Please provide a value.",
          );
        }
      },
    ));
  }

  @override
  void defaultValue(String value) {
    _compressor.registerValidator(
      JoiValidator(
        options: const ValidatorOptions(priority: JoiValidatorPriority.high),
        identifier: JoiIdentifier.defaultValue,
        nullValidator: () => value,
      ),
    );
  }

  void base64({bool padding = true, String? message}) {
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
  }

  void alphanum({String? message}) {
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
  }

  void uri({String? message}) {
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
  }

  @override
  void limit(int length, {String? message}) {
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
  }

  void valid(List<String> validValues,
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
  }

  void currencyCode({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.currencyCode,
      beforeValidation: (value) => value.trim(),
      validator: (value) {
        bool found = false;
        for (var currency in currencyCodes) {
          if (currency.toLowerCase() == value.toLowerCase()) {
            found = true;
            break;
          }
        }
        if (!found) {
          throw JoiTypeException(message ?? 'Not a currency code: $value');
        }
      },
    ));
  }

  void specialChar({String? message}) {
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
  }

  void creditCard({String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.creditCard,
      validator: (value) {
        if (!_isValidCreditCard(value)) {
          throw JoiTypeException(message ?? 'Not a valid credit card number');
        }
      },
    ));
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

  void num({String? message}) {
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
  }

  void date(String format, {String? message}) {
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
  }

  void countryCode({String? message}) {
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
  }

  void custom(JoiValidator<String> validator) {
    _compressor.registerValidator(validator);
  }

  void password({int minLen = 8, int? maxLen}) {
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
  }

  void image({String? message}) {
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
  }

  void start(String str, {String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.start,
      beforeValidation: (value) => value.trim(),
      validator: (value) {
        if (!value.startsWith(str)) {
          throw JoiTypeException("value does not start with $str");
        }
      },
    ));
  }

  void end(String str, {String? message}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.end,
      beforeValidation: (value) => value.trim(),
      validator: (value) {
        if (!value.endsWith(str)) {
          throw JoiTypeException("value does not end with $str");
        }
      },
    ));
  }

  void invalid(List<String> list,
      {String? message, bool caseSensitive = true}) {
    _compressor.registerValidator(JoiValidator(
      identifier: JoiIdentifier.invalid,
      beforeValidation: (value) {
        return value.trim();
      },
      validator: (value) {
        value = caseSensitive ? value : value.toLowerCase();
        list = caseSensitive ? list : list.map((e) => e.toLowerCase()).toList();
        if (list.contains(value)) {
          throw JoiTypeException("$value is not valid value");
        }
      },
    ));
  }
}
