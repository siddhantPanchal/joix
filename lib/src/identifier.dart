typedef Integer = int;
typedef Double = double;

final class JoiIdentifier {
  static Integer _custom = -1;

  static String get generate {
    _custom += 1;
    return "custom $_custom";
  }

  // * common methods
  static String get required => "required";
  static String get defaultValue => "defaultValue";
  static String get limit => "limit";
  static String get valid => "valid";

  // * number methods
  static String get int => "int";
  static String get decimal => "decimal";
  static String get double => "double";
  static String get divisible => "divisible";
  static String get positive => "positive";
  static String get negative => "negative";
  static String get min => "min";
  static String get max => "max";

  // * string methods
  static String get notEmpty => "notEmpty";
  static String get match => "match";
  static String get email => "email";
  static String get base64 => "base64";
  static String get alphanum => "alphanum";
  static String get uri => "uri";
  static String get currencySymbol => "currencySymbol";
  static String get currencyCode => "currencyCode";
  static String get specialChar => "specialChar";
  static String get creditCard => "creditCard";
  static String get num => "num";
  static String get date => "date";
  static String get countryCode => "countryCodeISO3166Alpha2";
  static String get password => "password";
  static String get start => "start";
  static String get end => "end";
  static String get invalid => "invalid";
}
