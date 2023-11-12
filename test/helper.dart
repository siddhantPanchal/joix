
import 'package:joix/joix.dart';
import 'package:test/test.dart';

void checkForPass(JoiResult result) {
  expect(result.isSuccess, true);
  expect(result.error, isNull);
}

void checkForFail(JoiResult result, String errorMessage) {
  expect(result.isSuccess, false);
  expect(result.error, isA<JoiTypeException>());
  expect(result.error!.message, errorMessage);
}
