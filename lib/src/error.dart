class JoiTypeException implements Exception {
  final String message;

  const JoiTypeException([this.message = ""]);

  @override
  String toString() => "JoiTypeException: $message";

  String toMessage() => message;
}
