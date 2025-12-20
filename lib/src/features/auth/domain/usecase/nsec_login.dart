import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:nostrrdr/src/features/auth/domain/entities/auth_user.dart';
import 'package:nostrrdr/src/core/errors/failures.dart';
import 'package:nostrrdr/src/core/usecase/usecase.dart';
import 'package:nostrrdr/src/features/auth/domain/repository/auth_repository.dart';

@lazySingleton
class NsecLoginUseCase implements UseCase<AuthUser, String> {
  final AuthRepository _repository;

  NsecLoginUseCase(this._repository);

  @override
  Future<Either<Failure, AuthUser>> call(String nsecOrHexPrivkey) async {
    return _repository.nsecLogin(nsecOrHexPrivkey);
  }
}
