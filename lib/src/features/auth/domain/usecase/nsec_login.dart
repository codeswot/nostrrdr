import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:marmot_flutter/marmot_flutter.dart' as marmot;
import 'package:nostrrdr/src/core/errors/failures.dart';
import 'package:nostrrdr/src/core/usecase/usecase.dart';
import 'package:nostrrdr/src/features/auth/domain/repository/auth_repository.dart';

@lazySingleton
class NsecLogin implements UseCase<marmot.Account, String> {
  final AuthRepository _repository;

  NsecLogin(this._repository);

  @override
  Future<Either<Failure, marmot.Account>> call(String nsecOrHexPrivkey) async {
    return _repository.nsecLogin(nsecOrHexPrivkey);
  }
}
