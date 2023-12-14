class DomainException implements Exception {
  DomainException(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}
