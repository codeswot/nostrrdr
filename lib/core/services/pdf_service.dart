import 'package:pdfrx/pdfrx.dart';

class PdfService {
  Future<int> getPageCount(String filePath) async {
    try {
      final document = await PdfDocument.openFile(filePath);
      return document.pages.length;
    } catch (e) {
      throw Exception('Failed to read PDF: $e');
    }
  }
}
