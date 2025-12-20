import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:nostrrdr/src/features/auth/domain/entities/auth_user.dart';
import 'package:nostrrdr/src/core/errors/failures.dart';
import 'package:nostrrdr/src/core/usecase/usecase.dart';
import 'package:nostrrdr/src/features/auth/domain/repository/auth_repository.dart';

@lazySingleton
class CreateIdentityUseCase implements UseCase<AuthUser, NoParams> {
  final AuthRepository _repository;

  CreateIdentityUseCase(this._repository);

  @override
  Future<Either<Failure, AuthUser>> call(NoParams params) async {
    return _repository.createIdentity();
  }
}
