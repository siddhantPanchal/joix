import 'package:joix/joix.dart';

import '../validator/validator_compressor.dart';

class JoiMapX extends JoiX<Map<Object, Object>> {
  final Map<Object, Object>? _value;
  final Map<Object, JoiX<Object>> _compressorMap;

  JoiMapX(Map<Object, JoiX<Object> Function(Object? value)> compressor,
      {required Map<Object, Object>? value})
      : _value = value,
        _compressorMap = compressor.map(
          (key, callback) => MapEntry(key, callback(value?[key])),
        ),
        super(ValidatorCompressor<Map<Object, Object>>());

  @override
  JoiResult<Map<Object, Object>> validate() {
    if (_value == null) {
      return JoiResult(
        isSuccess: false,
        error: JoiTypeException("given map is null"),
        value: value,
      );
    }
    for (final MapEntry(value: com) in _compressorMap.entries) {
      final result = com.validate();
      if (!result.isSuccess) {
        return JoiResult(
          isSuccess: result.isSuccess,
          error: result.error,
          value: value,
        );
      }
    }
    return JoiResult(isSuccess: true, error: null, value: value);
  }

  @override
  Map<Object, Object>? get value => _value;
}
