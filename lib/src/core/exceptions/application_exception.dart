class ApplicationException implements Exception {
  ApplicationException({
    required this.message,
    this.stackTrace,
  });

  final String message;
  final dynamic stackTrace;

  @override
  String toString() {
    return message;
  }
}
