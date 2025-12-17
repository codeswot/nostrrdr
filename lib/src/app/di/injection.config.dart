// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasource/auth_datasource.dart' as _i43;
import '../../features/auth/data/repository/auth_repository_impl.dart' as _i409;
import '../../features/auth/domain/repository/auth_repository.dart' as _i961;
import '../../features/auth/domain/usecase/create_identity.dart' as _i1070;
import '../../features/auth/domain/usecase/nsec_login.dart' as _i505;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i43.AuthDataSource>(
      () => _i43.AuthDataSourceImpl.create(),
    );
    gh.lazySingleton<_i961.AuthRepository>(
      () => _i409.AuthRepositoryImpl(authDataSource: gh<_i43.AuthDataSource>()),
    );
    gh.lazySingleton<_i1070.CreateIdentityUseCase>(
      () => _i1070.CreateIdentityUseCase(gh<_i961.AuthRepository>()),
    );
    gh.lazySingleton<_i505.NsecLoginUseCase>(
      () => _i505.NsecLoginUseCase(gh<_i961.AuthRepository>()),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(
        nsecLoginUseCase: gh<_i505.NsecLoginUseCase>(),
        createIdentityUseCase: gh<_i1070.CreateIdentityUseCase>(),
      ),
    );
    return this;
  }
}
