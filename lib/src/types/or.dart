part of "../joix_base.dart";

final class JoiOrX with JoiX<dynamic> {
  final List<JoiX<dynamic>> _schemas;

  JoiOrX({required List<JoiX> schemas}) : _schemas = schemas;

  @override
  JoiResult validate({value}) {
    for (final schema in _schemas) {
      JoiResult result;
      try {
        result = schema.validate(value: this.value);
        // ignore: unused_catch_clause
      } catch (e) {
        result = JoiResult(
          isSuccess: false,
          error: JoiTypeException(),
          value: this.value,
        );
      }
      if (result.isSuccess) {
        return result;
      }
    }
    return JoiResult(
      isSuccess: false,
      error: JoiTypeException(
          "${name ?? 'or validator'} is failed the validation"),
      value: value,
    );
  }
}
