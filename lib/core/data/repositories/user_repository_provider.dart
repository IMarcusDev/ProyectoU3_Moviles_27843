import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turismo_app/core/data/datasources/firebase_user_datasource.dart';
import 'package:turismo_app/core/data/repositories/user_repository_impl.dart';
import 'package:turismo_app/core/domain/repositories/user_repository.dart';

final userDatasourceProvider = Provider<FirebaseUserdataSource>((ref) {
  return FirebaseUserdataSource();
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final datasource = ref.read(userDatasourceProvider);
  return UserRepositoryImpl(datasource);
});
