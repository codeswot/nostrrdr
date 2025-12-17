import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marmot_flutter/marmot_flutter.dart' as marmot;
import 'package:nostrrdr/src/core/errors/failures.dart';
import 'package:nostrrdr/src/core/usecase/usecase.dart';
import 'package:nostrrdr/src/features/auth/domain/repository/auth_repository.dart';
import 'package:nostrrdr/src/features/auth/domain/usecase/create_identity.dart';

void main() {
  late CreateIdentityUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = CreateIdentityUseCase(mockAuthRepository);
  });

  final tAccount = MockAccount();

  test('should get account from the repository', () async {
    when(
      () => mockAuthRepository.createIdentity(),
    ).thenAnswer((_) async => Right(tAccount));

    final result = await useCase(NoParams());

    expect(result, Right(tAccount));
    verify(() => mockAuthRepository.createIdentity());
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return failure when repository fails', () async {
    when(
      () => mockAuthRepository.createIdentity(),
    ).thenAnswer((_) async => const Left(AppFailure('error')));

    final result = await useCase(NoParams());

    expect(result, const Left(AppFailure('error')));
    verify(() => mockAuthRepository.createIdentity());
    verifyNoMoreInteractions(mockAuthRepository);
  });
}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAccount extends Mock implements marmot.Account {}
