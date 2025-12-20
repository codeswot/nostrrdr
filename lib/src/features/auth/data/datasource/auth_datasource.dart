import 'package:injectable/injectable.dart';
import 'package:marmot_flutter/marmot_flutter.dart' as marmot;
import 'package:nostrrdr/src/core/errors/exeptions.dart';
import 'package:nostrrdr/src/features/auth/domain/entities/auth_user.dart';

typedef LoginFn =
    Future<marmot.Account> Function({required String nsecOrHexPrivkey});
typedef CreateIdentityFn = Future<marmot.Account> Function();

abstract class AuthDataSource {
  Future<AuthUser> nsecLogin(String nsecOrHexPrivkey);
  Future<AuthUser> createIdentity();
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  final LoginFn _loginFn;
  final CreateIdentityFn _createIdentityFn;

  @factoryMethod
  factory AuthDataSourceImpl.create() => AuthDataSourceImpl();

  AuthDataSourceImpl({
    LoginFn loginFn = marmot.login,
    CreateIdentityFn createIdentityFn = marmot.createIdentity,
  }) : _loginFn = loginFn,
       _createIdentityFn = createIdentityFn;

  @override
  Future<AuthUser> nsecLogin(String nsecOrHexPrivkey) async {
    try {
      final account = await _loginFn(nsecOrHexPrivkey: nsecOrHexPrivkey);
      return AuthUser(
        pubKey: account.pubkey,
        createdAt: account.createdAt,
        updatedAt: account.updatedAt,
        lastSyncedAt: account.lastSyncedAt,
      );
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<AuthUser> createIdentity() async {
    try {
      final account = await _createIdentityFn();
      return AuthUser(
        pubKey: account.pubkey,
        createdAt: account.createdAt,
        updatedAt: account.updatedAt,
        lastSyncedAt: account.lastSyncedAt,
      );
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
