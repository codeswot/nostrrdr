import 'dart:async';
import 'package:nostrrdr/core/services/logger_service.dart';
import 'package:nostrrdr/features/sync/repositories/sync_repository.dart';

class UploadRetryService {
  final SyncRepository _syncRepository;
  Timer? _retryTimer;

  static const Duration retryInterval = Duration(minutes: 5);

  UploadRetryService(this._syncRepository);

  void startPeriodicRetry() {
    if (_retryTimer != null) {
      LoggerService.debug('Retry timer already running');
      return;
    }

    LoggerService.debug('Starting periodic upload retry service');

    // Run initial check immediately
    _syncRepository.retryFailedUploads();

    // Schedule periodic retries every 5 minutes
    _retryTimer = Timer.periodic(retryInterval, (_) async {
      LoggerService.debug('Running scheduled upload retry');
      await _syncRepository.retryFailedUploads();
    });
  }

  void stopPeriodicRetry() {
    _retryTimer?.cancel();
    _retryTimer = null;
    LoggerService.debug('Stopped periodic upload retry service');
  }

  void dispose() {
    stopPeriodicRetry();
  }
}
