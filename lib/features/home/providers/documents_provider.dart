import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostrrdr/core/database/database.dart';
import 'package:nostrrdr/core/providers/database_provider.dart';
import 'package:nostrrdr/core/services/thumbnail_service.dart';
import 'package:nostrrdr/features/auth/providers/auth_provider.dart';
import 'package:nostrrdr/features/home/repositories/local_library_repository.dart';

final thumbnailServiceProvider = Provider<ThumbnailService>((ref) {
  return ThumbnailService();
});

final localLibraryRepositoryProvider = Provider<LocalLibraryRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return LocalLibraryRepository(database);
});

final documentsProvider = StreamProvider<List<Document>>((ref) {
  final repository = ref.watch(localLibraryRepositoryProvider);
  final npub = ref.watch(currentNpubProvider);

  if (npub == null) {
    return Stream.value([]);
  }

  return repository.watchDocuments(npub);
});

final documentProvider = FutureProvider.family<Document?, int>((ref, id) async {
  final repository = ref.watch(localLibraryRepositoryProvider);
  return repository.getDocument(id);
});
