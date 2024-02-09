part of "../joix_base.dart";

class JoiMapX with JoiX<Map<String, dynamic>> {
  late final Map<String, JoiX> _compressorMap;

  JoiMapX(Map<String, JoiX> validators,
      {required Map<String, dynamic>? value}) {
    _value = value;
    // don't need this compressor but for future reference
    _compressor = ValidatorCompressor<Map<String, dynamic>>();
    _compressorMap = validators.map(
      (key, value) => MapEntry(
        key,
        value
          ..name = key
          .._value = _value?[key],
      ),
    );
  }

  @override
  JoiResult<Map<String, dynamic>> validate({Map<String, dynamic>? value}) {
    if (value != null) _value = value;
    if (_value == null) {
      return JoiResult(
        isSuccess: false,
        error: JoiTypeException("given map is null"),
        value: _value,
      );
    }
    _createNewCompressor();
    for (final MapEntry(value: joi) in _compressorMap.entries) {
      JoiResult<dynamic> result;
      if (joi is JoiRefX) {
        var ref = _compressorMap[joi.key];
        result = _processJoiRef(joi, ref);
      } else {
        result = joi.validate();
      }
      if (!result.isSuccess) {
        return JoiResult(
          isSuccess: result.isSuccess,
          error: result.error,
          value: _value,
        );
      }
    }
    return JoiResult(isSuccess: true, error: null, value: _value);
  }

  JoiResult _processJoiRef(JoiX<dynamic> current, JoiX<dynamic>? ref) {
    if (ref == null) throw Exception("");
    final oldValue = ref.value;
    final value = current.value;

    final result = ref.validate(value: value);

    if (!result.isSuccess) {
      return JoiResult(
        isSuccess: result.isSuccess,
        error: result.error,
        value: _value,
      );
    }

    if (oldValue != value) {
      return JoiResult(
        isSuccess: false,
        error: JoiTypeException(
            "${current.name} value is not same as ${ref.name}"),
        value: _value,
      );
    }

    return result;
  }

  void _createNewCompressor() {
    final compressorMap = {..._compressorMap};
    compressorMap.addAll(compressorMap.map(
      (key, value) {
        var mapEntry = MapEntry(
          key,
          value
            ..name = key
            .._value = _value?[key],
        );

        return mapEntry;
      },
    ));
    _compressorMap.clear();
    _compressorMap.addAll(compressorMap);
  }
}
