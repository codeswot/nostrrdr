import 'dart:io';

import 'package:crypto/crypto.dart';

class FileHashService {
  static Future<String> calculateFileHash(String filePath) async {
    final file = File(filePath);

    if (!await file.exists()) {
      throw FileSystemException('File not found', filePath);
    }

    final bytes = await file.readAsBytes();
    return sha256.convert(bytes).toString();
  }
}
