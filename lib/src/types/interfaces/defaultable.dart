import '../../joix_base.dart';

abstract interface class Defaultable<T> {
  JoiX<T> defaultValue(T value);
}
