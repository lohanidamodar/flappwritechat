import 'package:appwrite/appwrite.dart';
import 'package:flappwritechat/models/channel.dart';
import 'package:flappwritechat/models/user.dart';
import 'package:flappwritechat/res/constants.dart';

class ApiService {
  final Client client = Client();
  Account account;
  Database db;
  static ApiService _instance;

  ApiService._internal() {
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);
    account = Account(client);
    db = Database(client);
  }

  static ApiService get instance {
    if (_instance == null) {
      _instance = ApiService._internal();
    }
    return _instance;
  }

  Future<bool> login({String email, String password}) async {
    try {
      await account.createSession(email: email, password: password);
      return true;
    } on AppwriteException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<User> getUser() async {
    try {
      final res = await account.get();
      return User.fromMap(res.data);
    } on AppwriteException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<Channel> addChannel(String title) async {
    try {
      final res = await db
          .createDocument(collectionId: AppConstants.channelsCollection, data: {
        "title": title,
      }, read: [
        'role:member'
      ], write: [
        'role:member'
      ]);
      return Channel.fromMap(res.data);
    } on AppwriteException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<List<Channel>> getChannels() async {
    try {
      final res =
          await db.listDocuments(collectionId: AppConstants.channelsCollection);
      return List<Map<String, dynamic>>.from(res.data['documents'])
          .map((e) => Channel.fromMap(e))
          .toList();
    } on AppwriteException catch (e) {
      print(e.message);
      return [];
    }
  }
}
