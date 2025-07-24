import 'package:merchandising_app/data/service/user/user_service.dart';
import 'package:merchandising_app/domain/models/user/user_model.dart';
import 'package:merchandising_app/domain/repositories/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserService userService;

  UserRepositoryImpl({required this.userService});

  @override
  Future<UserModel?> getUser(String uuid) async {
    UserModel? userModel;
    Map<String, dynamic>? response = await userService.get(uuid);
    if (response != null) {
      userModel = UserModel.fromJson(response);
    }
    return userModel;
  }
}
