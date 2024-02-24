import 'package:joix/joix.dart';

void emailExample() {
  final joiString = "".string()
    ..email()
    ..required();

  // {value: , result: false, error: The null cannot be empty. Please provide a value.}
  print(joiString.validate());
}

void ageExample() {
  final joiString = null.number()..required();
  // {value: null, result: false, error: The value is required. Please provide a valid value.}
  print(joiString.validate());
}

void mapExample() {
  final schema = JoiX.object({
    "email": JoiX.string()
      ..email()
      ..required(),
    "age": JoiX.num()..required()
  });
  // {value: {email: abc@example.com, age: 20}, result: true, error: null}
  final result = schema.validate(
    value: {"email": "abc@example.com", 'age': 20},
  );
  print(result);
}

void refExample() {
  final schema = joi.object({
    "confirm_password": JoiX.ref("password"),
    "password": JoiX.string()..required(),
  });

  var map = {"password": "abc", "confirm_password": "abcd"};
  var result = schema.validate(value: map);
  print(result);
}

void pipelineExample() {
  final schema = JoiX.object({
    "email": JoiX.string()
      ..email()
      ..required(),
    "age": JoiX.num()..required(),
    "pan": joi.string()
      ..alphanum()
      ..pipeline((value) {
        var joiStringX = value.joi()..limit(10);
        print(joiStringX.validate());
        return joiStringX;
      })
      ..pipeline((value) {
        var joiStringX = value.substring(0, 5).joi()
          ..alphabets()
          ..uppercase();
        print(joiStringX.validate());
        return joiStringX;
      })
      ..pipeline((value) {
        return value.substring(5, 9).joi()..num();
      })
      ..pipeline(
        (value) {
          return value[value.length - 1].joi()
            ..alphabets()
            ..uppercase();
        },
      )
      ..required(),
  });
  final result = schema.validate(
    value: {"email": "abc@example.com", 'age': 20, "pan": "23ZAABN18J"},
  );
  //{value: {email: abc@example.com, age: 20, pan: 23ZAABN18J}, result: false, error:  not a valid alphabets string}
  print(result);
}

// void conditionalExample() {
//   // if age is below 18 then company is null but, if age is 18 or above then company is must

//   final schema = JoiX.object({
//     "age": joi.num()..required(),
//     "company": (joi.ref("age").value as num) < 18 ? joi.string() : joi.string()
//       ..required(),
//   });
//   final result = schema.validate(value: {"age": "20"});

//   print(result);
// }

void orExample() {
  // if age is in String or in num
  final schema = JoiX.object({
    "age": joi.or([
      joi.num()..required(),
      joi.string()
        ..num()
        ..required()
    ]),
  });
  final result = schema.validate(value: {"age": "20"});

  print(result);
}

void main() {
  // emailExample();
  // ageExample();
  // mapExample();
  // refExample();
  // pipelineExample();
  // orExample();
  // conditionalExample();
}
