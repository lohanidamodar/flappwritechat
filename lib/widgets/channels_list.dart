import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:flappwritechat/models/channel.dart';
import 'package:flappwritechat/res/constants.dart';
import 'package:flappwritechat/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final titleControllerProvider = Provider((ref) => TextEditingController());

class ChannelsList extends StatefulWidget {
  final Function(Channel) onTapChannel;
  final Channel? selectedChannel;

  const ChannelsList(
      {Key? key, required this.onTapChannel, this.selectedChannel})
      : super(key: key);
  @override
  _ChannelsListState createState() => _ChannelsListState();
}

class _ChannelsListState extends State<ChannelsList> {
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
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: channels.length,
        itemBuilder: (context, index) {
          final channel = channels[index];
          return ListTile(
            selected: channel == widget.selectedChannel,
            title: Text(channel.title),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await ApiService.instance.deleteChannel(channel);
              },
            ),
            onTap: () => widget.onTapChannel(channel),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey.shade300,
        elevation: 0,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60,
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, 'profile'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                    await ApiService.instance.addChannel(_controller.text);
                    _controller.clear();
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
