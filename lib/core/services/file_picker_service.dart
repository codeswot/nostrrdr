import 'package:file_picker/file_picker.dart';

class FilePickerService {
  Future<String?> pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files.single.path;
    }

    return null;
  }
}
