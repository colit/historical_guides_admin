import 'package:hive/hive.dart';

import '../exeptions/general_exeption.dart';
import 'interfaces/i_user_repository.dart';

class UserService {
  UserService({required IUsersRepository usersRepository})
      : _usersRepository = usersRepository;

  final IUsersRepository _usersRepository;

  String? _sessionToken;

  bool get loggedIn => _sessionToken != null;

  Future<void> doUserLogin(String username, String password) async {
    _sessionToken = await _usersRepository.doUserLogin(username, password);
    print('"X-Parse-Session-Token": "$_sessionToken"');
    try {
      var box = Hive.box('settings');
      box.put('sessionToken', _sessionToken);
    } on HiveError catch (e) {
      throw GeneralExeption(title: 'Hive error', message: e.message);
    }
  }

  void doUserLogout() {}

  Future<bool> validateToken(token) async {
    final result = await _usersRepository.validateToken(token);
    return result;
  }

  // Future<bool> hasUserLogged() async {
  //   final logged = await _usersRepository.hasUserLogged();
  //   return logged;
  // }
}
