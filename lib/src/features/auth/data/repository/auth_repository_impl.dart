import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:logging/logging.dart';
import 'package:nostrrdr/src/core/errors/failures.dart';
import 'package:nostrrdr/src/features/auth/data/datasource/auth_datasource.dart';
import 'package:nostrrdr/src/features/auth/domain/repository/auth_repository.dart';
import 'package:nostrrdr/src/features/auth/domain/entities/auth_user.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;
  final _logger = Logger('AuthRepositoryImpl');

  AuthRepositoryImpl({required this.authDataSource});

  @override
  Future<Either<Failure, AuthUser>> createIdentity() async {
    try {
      final account = await authDataSource.createIdentity();
      return Right(account);
    } catch (e, st) {
      _logger.severe('Create Identity Failed', e, st);
      return Left(AppFailure('Failed to create identity'));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> nsecLogin(String nsecOrHexPrivkey) async {
    try {
      final account = await authDataSource.nsecLogin(nsecOrHexPrivkey);
      return Right(account);
    } catch (e, st) {
      _logger.severe('Nsec Login Failed', e, st);
      return Left(AppFailure('Failed to login'));
    }
  }
}
