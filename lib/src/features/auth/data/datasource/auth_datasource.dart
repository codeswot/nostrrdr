import 'package:injectable/injectable.dart';
import 'package:marmot_flutter/marmot_flutter.dart' as marmot;
import 'package:nostrrdr/src/core/errors/exeptions.dart';

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

  @factoryMethod
  factory AuthDataSourceImpl.create() => AuthDataSourceImpl();

  AuthDataSourceImpl({
    LoginFn loginFn = marmot.login,
    CreateIdentityFn createIdentityFn = marmot.createIdentity,
  }) : _loginFn = loginFn,
       _createIdentityFn = createIdentityFn;

  @override
  Future<marmot.Account> nsecLogin(String nsecOrHexPrivkey) async {
    try {
      return await _loginFn(nsecOrHexPrivkey: nsecOrHexPrivkey);
    } catch (e) {
      throw AppException(e.toString());
    }
  }

  @override
  Future<marmot.Account> createIdentity() async {
    try {
      return await _createIdentityFn();
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
