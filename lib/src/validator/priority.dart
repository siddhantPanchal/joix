enum JoiValidatorPriority {
  high,
  medium,
  low,
}

extension ComparablePriority on JoiValidatorPriority {
  int compareTo(JoiValidatorPriority other) {
    return index.compareTo(other.index);
  }
}
