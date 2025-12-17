abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure &&
        other.runtimeType == runtimeType &&
        other.message == message;
  }

  @override
  int get hashCode => message.hashCode ^ runtimeType.hashCode;
}

class RelayFailure extends Failure {
  const RelayFailure([super.message = 'Relay failure']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache failure']);
}

class AppFailure extends Failure {
  const AppFailure([super.message = 'An unknown error occurred']);
}
