class DatabaseExecException implements Exception {
  final String message;

  DatabaseExecException(this.message);

  @override
  String toString() {
    return message;
  }
}
