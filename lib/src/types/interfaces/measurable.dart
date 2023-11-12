import '../../joix_base.dart';

abstract interface class Limitable<T> {
  JoiX<T> limit(int length);
}
