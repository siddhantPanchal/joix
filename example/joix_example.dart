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

void main() {
  emailExample();
  ageExample();
  mapExample();
}
