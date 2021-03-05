import 'package:appwrite/appwrite.dart';
import 'package:flappwritechat/models/user.dart';
import 'package:flappwritechat/res/constants.dart';

class ApiService {
  final Client client = Client();
  Account account;
  static ApiService _instance;

  ApiService._internal() {
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);
    account = Account(client);
  }

  static ApiService get instance {
    if(_instance == null) {
      _instance = ApiService._internal();
    }
    return _instance;
  }

  Future<bool> login({String email, String password}) async {
    try {
      await account.createSession(email: email, password: password);
      return true;
    } on AppwriteException catch(e) {
      print(e.message);
      return false;
    }
  }

  Future<User> getUser() async {
    try {
      final res = await account.get();
      return User.fromMap(res.data);
    } on AppwriteException catch(e) {
      print(e.message);
      return null;
    }
  }
}
