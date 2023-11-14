import 'types/num.dart';
import 'types/string.dart';
import 'validator/validator_compressor.dart';

extension JoiString on String? {
  JoiStringX joi() {
    return JoiStringX(ValidatorCompressor<String>(), value: this);
  }
}

extension JoiNumber on num? {
  JoiNumberX joi() {
    return JoiNumberX(ValidatorCompressor<num>(), value: this);
  }
}

// extension JoiObject on Object? {
//   JoiX joi() {
//     if (this == null) {
//       return (this as String).joi();
//     }
//     throw const JoiTypeException("cannot infer the type into joi object");
//   }
// }
// extension JoiObject on Null {
//   JoiX joi() {
//     if (this == null) {
//       return (this as String).joi();
//     }
//     throw const JoiTypeException("cannot infer the type into joi object");
//   }
// }
