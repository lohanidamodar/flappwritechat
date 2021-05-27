import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:flappwritechat/models/channel.dart';
import 'package:flappwritechat/models/user.dart';
import 'package:flappwritechat/res/constants.dart';
// import 'package:websok/html.dart';
// import 'package:websok/websok.dart';

class ApiService {
  final Client client = Client();
  late Account account;
  late Database db;
  late Realtime realtime;
  static ApiService? _instance;

  ApiService._internal() {
    client
        .setEndpoint(AppConstants.endpoint)
        .setProject(AppConstants.projectId);
    account = Account(client);
    db = Database(client);
    realtime = Realtime(client);
  }

  static ApiService get instance {
    if (_instance == null) {
      _instance = ApiService._internal();
    }
    return _instance!;
  }

  Future<bool> signup(
      {required String name,
      required String email,
      required String password}) async {
    try {
      await account.create(name: name, email: email, password: password);
      return true;
    } on AppwriteException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      await account.createSession(email: email, password: password);
      return true;
    } on AppwriteException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await account.deleteSessions();
      return true;
    } on AppwriteException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<User?> getUser() async {
    try {
      final res = await account.get();
      return User.fromMap(res.data);
    } on AppwriteException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future<Channel?> addChannel(String title) async {
    try {
      final res = await db.createDocument(
        collectionId: AppConstants.channelsCollection,
        data: {
          "title": title,
        },
        read: ['role:member'],
        write: ['role:member'],
      );
      return Channel.fromMap(res.data);
    } on AppwriteException catch (e) {
      print(e.message);
      return null;
    }
  }

  RealtimeSubscription realTimeChannels(String channel) {
    return realtime.subscribe([channel]);
    /* final sok = HTMLWebsok(
        host: AppConstants.host,
        path: 'v1/realtime',
        tls: false,
        query: {
          "project": AppConstants.projectId,
          "channels[]": "documents.$channel",
        })
      ..connect();
    return sok; */
  }

  addMessage(
      {required Map<String, dynamic> data, required String channelId}) async {
    try {
      await db.createDocument(
        collectionId: AppConstants.messagesCollection,
        data: data,
        read: ['role:member', "*"],
        write: ['user:${data["senderId"]}'],
        parentDocument: channelId,
        parentProperty: 'messages',
        parentPropertyType: 'append',
      );
    } on AppwriteException catch (e) {
      print(e.message);
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
