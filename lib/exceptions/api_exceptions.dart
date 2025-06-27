class NotFoundException implements Exception {
  final String message;

  NotFoundException([this.message = 'Resource not found']);

  @override
  String toString() => 'NotFoundException: $message';
}

class FoundOtherException implements Exception {
  final String message;

  FoundOtherException([this.message = 'Resource not found']);

  @override
  String toString() => 'FoundOtherException: $message';
}