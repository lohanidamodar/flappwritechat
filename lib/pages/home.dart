import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:flappwritechat/models/channel.dart';
import 'package:flappwritechat/res/constants.dart';
import 'package:flappwritechat/services/api_service.dart';
import 'package:flappwritechat/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final titleControllerProvider = Provider((ref) => TextEditingController());

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  late List<Channel> channels;
  RealtimeSubscription? subscription;

  @override
  void initState() {
    super.initState();
    channels = [];
    _getChannels();
    try {
      if (subscription != null) return;
      subscription = ApiService.instance.realTimeChannels(
          "collections.${AppConstants.channelsCollection}.documents");
      subscription?.stream.listen((data) {
        data = json.decode(data);
        print(data);
        if (data["payload"] != null) {
          switch (data["event"]) {
            case "database.documents.create":
              var channel = Channel.fromMap(data['payload']);
              if (!channels.contains(channel)) {
                channels.add(channel);
                setState(() {});
              }
              break;
            case "database.documents.delete":
              var channel = Channel.fromMap(data['payload']);
              channels.removeWhere((element) => element.id == channel.id);
              setState(() {});
              break;
            case "database.documents.update":
              var channel = Channel.fromMap(data['payload']);
              channels = channels
                  .map((old) => old.id == channel.id ? channel : old)
                  .toList();
              setState(() {});
              break;
            default:
              break;
          }
        }
      });
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  _getChannels() async {
    try {
      channels = await ApiService.instance.getChannels();
      setState(() {});
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  @override
  void dispose() {
    subscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, 'profile'),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: channels.length,
        itemBuilder: (context, index) {
          final channel = channels[index];
          return ListTile(
            title: Text(channel.title),
            onTap: () =>
                Navigator.pushNamed(context, 'chat', arguments: channel),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Add Channel"),
              content: TextField(
                controller: _controller,
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final channel =
                        await ApiService.instance.addChannel(_controller.text);
                    /* if (channel != null) {
                      final cp = context.read(channelsProvider);
                      final channels = cp.state;
                      channels.add(channel);
                      cp.state = channels;
                    } */
                    Navigator.pop(context);
                  },
                  child: Text("Save"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
