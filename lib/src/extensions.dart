import 'package:joix/src/error.dart';
import 'package:joix/src/joix_base.dart';

import 'types/map.dart';
import 'types/num.dart';
import 'types/string.dart';
import 'validator/validator_compressor.dart';

extension JoiString on String? {
  JoiStringX joi({String? name}) {
    return JoiStringX(ValidatorCompressor<String>(), value: this);
  }
}

extension JoiNumber on num? {
  JoiNumberX joi({String? name}) {
    return JoiNumberX(ValidatorCompressor<num>(), value: this);
  }
}

extension JoiMap on Map<Object, Object>? {
  JoiMapX joi(Map<Object, JoiX<Object> Function(Object? value)> callback,
      {String? name}) {
    return JoiMapX(callback, value: this);
  }
}

extension JoiXExtension on Object? {
  JoiStringX string() {
    if (this is String?) {
      return (this as String?).joi();
    }

    throw JoiTypeException("$this is not a string");
  }

  JoiNumberX number() {
    if (this is num?) {
      return JoiNumberX(ValidatorCompressor<num>(), value: this as num?);
    }
    throw JoiTypeException("$this is not a number");
  }

  JoiMapX map(Map<Object, JoiX<Object> Function(Object? value)> callback) {
    if (this is Map?) {
      return JoiMapX(callback, value: this as Map<Object, Object>);
    }
    throw JoiTypeException("$this is not a map");
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
