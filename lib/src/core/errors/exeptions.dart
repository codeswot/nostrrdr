class AppException implements Exception {
  final String message;
  AppException([this.message = 'App error occurred']);
}

class RelayException implements Exception {
  final String message;
  RelayException([this.message = 'Relay error occurred']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error occurred']);
}
