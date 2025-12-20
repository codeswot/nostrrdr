import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nostrrdr/src/core/errors/failures.dart';
import 'package:nostrrdr/src/features/auth/domain/entities/auth_user.dart';
import 'package:nostrrdr/src/features/auth/domain/repository/auth_repository.dart';
import 'package:nostrrdr/src/features/auth/domain/usecase/nsec_login.dart';

void main() {
  late NsecLoginUseCase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = NsecLoginUseCase(mockAuthRepository);
  });

  const tNsec = 'nsec123456';
  final tAuthUser = MockAuthUser();

  test('should get authUser from the repository', () async {
    when(
      () => mockAuthRepository.nsecLogin(any()),
    ).thenAnswer((_) async => Right(tAuthUser));

    final result = await useCase(tNsec);

    expect(result, Right(tAuthUser));
    verify(() => mockAuthRepository.nsecLogin(tNsec));
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return failure when repository fails', () async {
    when(
      () => mockAuthRepository.nsecLogin(any()),
    ).thenAnswer((_) async => const Left(AppFailure('error')));

    final result = await useCase(tNsec);

    expect(result, const Left(AppFailure('error')));
    verify(() => mockAuthRepository.nsecLogin(tNsec));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthUser extends Mock implements AuthUser {}
