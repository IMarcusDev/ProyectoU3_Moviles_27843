import 'package:turismo_app/core/domain/entities/user.dart';

abstract class UserRepository {
  Future<User?> loginUser(String email, String password);
  Future<User?> fetchUser(String id);
  Future<User> createUser(User u);
  Future<User> modifyUser(User u);

  Future<bool> ratePlace(String uId, String pId, int ratingStars);
}
