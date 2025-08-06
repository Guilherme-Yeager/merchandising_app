import 'package:merchandising_app/domain/models/user/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> getUser(String uuid);
}
