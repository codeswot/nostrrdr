class DuplicateDocumentException implements Exception {
  final String message;
  final String existingDocumentId;

  DuplicateDocumentException(
    this.message, {
    required this.existingDocumentId,
  });

  @override
  String toString() => message;
}
