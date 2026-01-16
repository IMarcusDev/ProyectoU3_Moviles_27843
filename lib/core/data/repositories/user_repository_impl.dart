import 'package:turismo_app/core/data/datasources/firebase_user_datasource.dart';
import 'package:turismo_app/core/domain/entities/user.dart';
import 'package:turismo_app/core/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final FirebaseUserdataSource remote;

  UserRepositoryImpl(this.remote);

  @override
  Future<User> createUser(User u) {
    return remote.createUser(u);
  }

  @override
  Future<User?> fetchUser(int id) {
    return remote.fetchUser(id);
  }

  @override
  Future<User> modifyUser(User u) {
    return remote.updateUser(u);
  }
  
  @override
  Future<User?> loginUser(String email, String password) {
    // Hash password
    return remote.loginUser(email, password);
  }
}
