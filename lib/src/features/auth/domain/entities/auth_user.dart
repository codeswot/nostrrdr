import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.pubKey,
    required this.createdAt,
    required this.updatedAt,
    this.lastSyncedAt,
  });

  final String pubKey;
  final DateTime? lastSyncedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [pubKey, lastSyncedAt, createdAt, updatedAt];
}
