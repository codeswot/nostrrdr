import 'package:dartz/dartz.dart';
import 'package:nostrrdr/src/core/errors/failures.dart';
import 'package:nostrrdr/src/features/auth/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> nsecLogin(String nsecOrHexPrivkey);
  Future<Either<Failure, AuthUser>> createIdentity();
}
