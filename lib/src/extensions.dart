import 'package:joix/src/error.dart';
import 'package:joix/src/joix_base.dart';

extension JoiString on String? {
  JoiStringX joi({String? name}) {
    return JoiStringX(value: this);
  }
}

extension JoiNumber on num? {
  JoiNumberX joi({String? name}) {
    return JoiNumberX(value: this);
  }
}

// extension JoiMap on Map<String, >? {
//   JoiMapX<JoiX<>> joi({String? name}) {
//     return JoiMapX<V>(value: this) /* = name */;
//   }
// }

extension JoiXExtension on Object? {
  JoiStringX string() {
    if (this is String?) {
      return (this as String?).joi();
    }

    throw JoiTypeException("$this is not a string");
  }

  JoiNumberX number() {
    if (this is num?) {
      return JoiNumberX(value: this as num?);
    }
    throw JoiTypeException("$this is not a number");
  }

  // JoiMapX<Object> map() {
  //   if (this is Map?) {
  //     return JoiMapX<Object>(value: this as Map<String, Object>);
  //   }
  //   throw JoiTypeException("$this is not a map");
  // }
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
