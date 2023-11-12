import 'package:joix/joix.dart';

void main() {
  final joiString = "some value".joi();
  final result =
      joiString.notEmpty().start("some").end("ue").required().validate();
  print(result.toString());
}
