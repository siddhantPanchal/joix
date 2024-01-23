import 'package:joix/joix.dart';

void main() {
  final joiString = "some value".joi();
  final result = joiString
                    ..notEmpty()
                    ..email();
  print(result.validate());
}
