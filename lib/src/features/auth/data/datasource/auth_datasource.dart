import 'package:injectable/injectable.dart';
import 'package:marmot_flutter/marmot_flutter.dart' as marmot;

typedef LoginFn =
    Future<marmot.Account> Function({required String nsecOrHexPrivkey});
typedef CreateIdentityFn = Future<marmot.Account> Function();

abstract class AuthDataSource {
  Future<marmot.Account> nsecLogin(String nsecOrHexPrivkey);
  Future<marmot.Account> createIdentity();
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  final LoginFn _loginFn;
  final CreateIdentityFn _createIdentityFn;

  AuthDataSourceImpl({
    LoginFn loginFn = marmot.login,
    CreateIdentityFn createIdentityFn = marmot.createIdentity,
  }) : _loginFn = loginFn,
       _createIdentityFn = createIdentityFn;

  @factoryMethod
  factory AuthDataSourceImpl.create() => AuthDataSourceImpl();

  @override
  Future<marmot.Account> nsecLogin(String nsecOrHexPrivkey) =>
      _loginFn(nsecOrHexPrivkey: nsecOrHexPrivkey);

  @override
  Future<marmot.Account> createIdentity() => _createIdentityFn();
}
