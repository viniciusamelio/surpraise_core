class ValidationException implements Exception {
  ValidationException(
    this.message,
  );
  final String message;

  @override
  String toString() {
    return message;
  }
}
