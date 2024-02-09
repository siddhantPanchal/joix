import 'package:joix/joix.dart';
import 'package:test/test.dart';

import '../../helper.dart';

void main() {
  group(
    'map validation testing',
    () {
      group("create an map joix object", () {
        test("create a map joix object using non recommended way", () {
          var map = JoiMapX({}, value: {});
          expect(map, isA<JoiMapX>());
        });
        test("create a map joix object using recommended way", () {
          var map = JoiX.object({});
          expect(map, isA<JoiMapX>());
        });
      });

      group("validate the map value", () {
        test("validate the map value when valid values are passed in map value",
            () {
          final schema = JoiX.object({
            'name': JoiX.string()
              ..max(10)
              ..required(),
            'age': JoiX.num()..int(),
            'gender': JoiX.string()
              ..valid(['male', 'female', 'other'], caseSensitive: false)
              ..required(),
            'city': JoiX.string(),
            'country': JoiX.string()..countryCode(),
            'email': JoiX.string()
              ..email()
              ..required(),
            'phone': JoiX.string()
              ..match(RegExp(r'\+\d+'))
              ..required(),
            'occupation': JoiX.string(),
            'hobby': JoiX.string()
              ..valid(["reading", "writing", "swimming", "ridding"]),
            'favorite_color': JoiX.string()
              ..valid(["blue", "green", "yellow", "red", "violet"]),
          });

          var map = {
            'name': 'Alice',
            'age': 25,
            'gender': 'female',
            'city': 'Mumbai',
            'country': 'IN',
            'email': 'alice@gmail.com',
            'phone': '+91-9876543210',
            'occupation': 'software engineer',
            'hobby': 'reading',
            'favorite_color': 'blue'
          };
          var result = schema.validate(value: map);
          // print(result);
          checkForPass(result);
        });

        test("validate the map value when valid values are passed in map value",
            () {
          final schema = joi.object({
            "confirm_password": JoiX.ref("password"),
            "password": JoiX.string()..required(),
          });

          var map = {"password": "abc", "confirm_password": "abc"};
          var result = schema.validate(value: map);
          print(result);
          checkForPass(result);
        });
        test(
            "validate the map value when invalid values are passed in map value",
            () {
          final schema = joi.object({
            "confirm_password": JoiX.ref("password"),
            "password": JoiX.string()..required(),
          });

          var map = {"password": "abc", "confirm_password": "abcd"};
          var result = schema.validate(value: map);
          checkForFail(
              result, "confirm_password value is not same as password");
        });

        test(
            "validate the map value when invalid values are passed in map value",
            () {
          final schema = JoiX.object({
            'name': JoiX.string()
              ..max(10)
              ..required(),
            'age': JoiX.num()..int(),
            'gender': JoiX.string()
              ..valid(['male', 'female', 'other'], caseSensitive: false)
              ..required(),
            'city': JoiX.string(),
            'country': JoiX.string()..countryCode(),
            'email': JoiX.string()
              ..email()
              ..required(),
            'phone': JoiX.string()
              ..match(RegExp(r'\+\d+'))
              ..required(),
            'occupation': JoiX.string(),
            'hobby': JoiX.string()
              ..valid(["reading", "writing", "swimming", "ridding"]),
            'favorite_color': JoiX.string()
              ..valid(["blue", "green", "yellow", "red", "violet"]),
          });

          var map = {
            'name': 'Alice',
            'age': 25,
            'gender': 'female1',
            'city': 'Mumbai',
            'country': 'IN',
            'email': 'alice@gmail.com',
            'phone': '+91-9876543210',
            'occupation': 'software engineer',
            'hobby': 'reading',
            'favorite_color': 'blue'
          };
          var result = schema.validate(value: map);
          // print(result);
          checkForFail(
              result, "Not one of the valid values: [male, female, other]");
        });
      });
    },
  );
}
