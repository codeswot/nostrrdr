import 'dart:io';

import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:nostrrdr/core/services/logger_service.dart';

class ThumbnailService {
  static const String _thumbnailDir = 'thumbnails';
  static const int _maxRetries = 3;

  /// Validates if a thumbnail path is valid and the file exists
  Future<bool> validateThumbnailPath(String? thumbnailPath) async {
    if (thumbnailPath == null || thumbnailPath.isEmpty) {
      return false;
    }

    final file = File(thumbnailPath);
    if (!await file.exists()) {
      return false;
    }

    final dir = file.parent;
    if (!await dir.exists()) {
      return false;
    }

    return true;
  }

  /// Validates and regenerates thumbnail if needed, with retry logic
  /// Returns the valid thumbnail path or null after max retries
  Future<String?> validateAndRegenerateThumbnail({
    required String? currentThumbnailPath,
    required String pdfPath,
    required String documentId,
  }) async {
    // First, validate the current path
    if (await validateThumbnailPath(currentThumbnailPath)) {
      return currentThumbnailPath;
    }

    // If validation failed, attempt to regenerate with retries
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        LoggerService.info(
          'Attempting to regenerate thumbnail for $documentId (attempt ${attempt + 1}/$_maxRetries)',
        );

        // Add exponential backoff delay for retries
        if (attempt > 0) {
          await Future.delayed(Duration(milliseconds: 100 * attempt));
        }

        final newThumbnailPath = await generateThumbnail(pdfPath, documentId);

        if (newThumbnailPath != null &&
            await validateThumbnailPath(newThumbnailPath)) {
          LoggerService.info(
            'Successfully regenerated thumbnail for $documentId on attempt ${attempt + 1}',
          );
          return newThumbnailPath;
        }
      } catch (e, st) {
        LoggerService.error(
          'Failed to regenerate thumbnail for $documentId on attempt ${attempt + 1}',
          e,
          st,
        );
      }
    }

    LoggerService.error(
      'Failed to regenerate thumbnail for $documentId after $_maxRetries attempts',
      null,
      null,
    );
    return null;
  }

  Future<String?> generateThumbnail(String pdfPath, String documentId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final thumbnailDir = Directory('${appDir.path}/$_thumbnailDir');

      if (!await thumbnailDir.exists()) {
        await thumbnailDir.create(recursive: true);
      }

      final thumbnailPath = '${thumbnailDir.path}/$documentId.png';
      final thumbnailFile = File(thumbnailPath);

      if (await thumbnailFile.exists()) {
        return thumbnailPath;
      }

      final doc = await PdfDocument.openFile(pdfPath);
      if (doc.pages.isEmpty) return null;

      final page = doc.pages[0];
      final pageImage = await page.render(fullWidth: 300, fullHeight: 400);

      if (pageImage == null) return null;

      final image = await pageImage.createImage();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        await thumbnailFile.writeAsBytes(byteData.buffer.asUint8List());
        return thumbnailPath;
      }

      return null;
    } catch (e, st) {
      LoggerService.error('Failed to generate thumbnail for $pdfPath', e, st);
      return null;
    }
  }

  Future<void> deleteThumbnail(String documentId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final thumbnailPath = '${appDir.path}/$_thumbnailDir/$documentId.png';
      final file = File(thumbnailPath);

      if (await file.exists()) {
        await file.delete();
      }
    } catch (e, st) {
      LoggerService.error('Failed to delete thumbnail for $documentId', e, st);
    }
  }
}
