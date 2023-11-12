import 'priority.dart';

class ValidatorOptions {
  final JoiValidatorPriority _priority;
  JoiValidatorPriority get priority => _priority;

  final bool _override;
  bool get override => _override;

  const ValidatorOptions({
    JoiValidatorPriority priority = JoiValidatorPriority.low,
    bool override = true,
  })  : _priority = priority,
        _override = override;
}
