
# JoiX - Unleash the Power 💪 of Dart Validation 🎉
Welcome to JoiX, where validating data becomes a breeze, and writing expressive validation rules feels like crafting a masterpiece. Inspired by the elegance of Joi.js, JoiX is your go-to validation library for Dart, designed to bring joy and simplicity to your data validation journey.


[![joix](https://img.shields.io/badge/pub-v1.0.0-blue.svg)](https://www.joix.com) 
[![joix](https://img.shields.io/badge/github-joix-white.svg)](https://github.com/siddhantPanchal/joix)

## Features

- Fluent API: Easily define validation rules using a chainable and readable syntax, creating concise and expressive validations.
- Comprehensive Validation: JoiX supports a wide range of validations, including string formats, numerical constraints, length checks, and more, ensuring you have the flexibility to validate various data types effectively.
- Modular Design: JoiX follows a modular design, allowing you to easily extend and customize validation rules based on your application's specific needs.
- Exception-based Validation: Validation failures result in JoiTypeException exceptions, providing a clean and straightforward way to handle and communicate validation errors in your code.


## Getting started

To use JoiX in your Dart project, add it to your `pubspec.yaml`:
```yaml
dependencies:
  joix: ^1.0.0
```
Then run:
```bash
dart pub get
```

## Usage

```dart
import 'package:joix/joix.dart';

void main() {
  try {
    final email = "example@email.com".joi().email().validate().value!;
    print("Validation passed!");
  } on JoiTypeException catch (e) {
    print("Validation failed: $e");
  }
}
```
or 
```dart
import 'package:joix/joix.dart';

void main() {
  final joiString = "some value".joi();
  final result =
      joiString.notEmpty().start("some").end("ue").required().validate();
  if (result.isSuccess) {
    print("validation succeeded");
  } else {
    print("validation failed ${result.error?.message}");
  }
}
```
or if you use Flutter Form
```dart
TextFormField(
  controller: _emailController,
  decoration: const InputDecoration(
    labelText: "Email Address",
  ),
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    final result = value
        .joi()
        .required(message: "Email address is required")
        .email(
          message: "Please enter a valid email address",
        ) // custom message
        .validate();

    return result.error?.message;
  },
),
```
let's breakdown above joi validation code

- `value.joi()` - Create a JoiX instance for the provided value. This is the starting point for building validation rules for the given value.

- `.required(message: "Email address is required")` - Make the email address required. If the provided value is null or an empty string, a `JoiTypeException` with the specified custom error message ("Email address is required") will be thrown.

- `.email(message: "Please enter a valid email address")` - Validate the value as an email address using the built-in email validation rule. If the validation fails, a `JoiTypeException` with the specified custom error message ("Please enter a valid email address") will be thrown.

- `.validate()` - Trigger the validation process. If the value passes all the defined validation rules, the result variable will hold the validated value. If any validation rule fails, a `JoiTypeException` will be thrown, and you can handle it accordingly in your code.


This chain of methods allows you to create a concise and expressive validation flow, ensuring that the provided value meets the specified criteria. The use of custom error messages provides clear and user-friendly feedback when validations fail.
## Additional information

