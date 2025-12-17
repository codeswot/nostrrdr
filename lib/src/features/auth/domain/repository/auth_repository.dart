import 'package:dartz/dartz.dart';
import 'package:nostrrdr/src/core/errors/failures.dart';
import 'package:marmot_flutter/marmot_flutter.dart' as marmot;

abstract class AuthRepository {
  Future<Either<Failure, marmot.Account>> nsecLogin(String nsecOrHexPrivkey);
  Future<Either<Failure, marmot.Account>> createIdentity();
}
