

import 'joix_base.dart';
import 'types/num.dart';
import 'types/string.dart';

extension JoiString on String? {
  JoiStringX joi() {
    return JoiX.string(this);
  }
}

extension JoiNumber on num? {
  JoiNumberX joi() {
    return JoiX.number(this);
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
