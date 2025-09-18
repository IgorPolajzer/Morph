class RequestException implements Exception {
  String cause;
  RequestException(this.cause);
}
