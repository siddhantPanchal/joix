import '../error.dart';
import '../identifier.dart';
import '../joix_base.dart';
import 'priority.dart';
import 'validator.dart';

class ValidatorCompressor<T> {
  Map<String, JoiValidator<T>> _validators;

  ValidatorCompressor() : _validators = <String, JoiValidator<T>>{};

  void registerValidator(JoiValidator<T> validator) {
    if (!_validators.containsKey(validator.identifier) ||
        validator.options.override) {
      _validators.addAll({validator.identifier: validator});
      return;
    }

    _validators.addAll(
      {'${validator.identifier}_${JoiIdentifier.generate}': validator},
    );
  }

  JoiResult<T> validate(T? value) {
    try {
      _calculatePriorities();
      var newValue = value;
      for (var MapEntry(value: validator) in _validators.entries) {
        newValue = validator(newValue);
      }

      return JoiResult<T>(isSuccess: true, error: null, value: value);
    } on JoiTypeException catch (e) {
      return JoiResult<T>(isSuccess: false, error: e, value: value);
    }
  }

  void _calculatePriorities() {
    final sorted = _validators.entries.toList()
      ..sort((a, b) {
        return a.value.options.priority.compareTo(b.value.options.priority);
      });
    final newValidators = Map<String, JoiValidator<T>>.fromEntries(sorted);
    _validators = newValidators;
  }
}
