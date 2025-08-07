abstract class UserRepository {
  Future<Map<String, dynamic>?> getUser(String uuid);
}
