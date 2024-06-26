import 'package:melonandmelon/data/repository/user_repository.dart';
import 'package:melonandmelon/models/user_model.dart';

class UserProvider extends UserTemplate {
  final UserRepository _userRepository;
  UserProvider({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<bool> createUser({required UserModel user}) {
    return _userRepository.createUser(user: user);
  }

  @override
  Future<UserModel> getUser() {
     return _userRepository.getUser();
  }

  @override
  Future<bool> updateUser({required UserModel user}) {
    return _userRepository.updateUser(user: user);
  }
}
