import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:flappwritechat/models/channel.dart';
import 'package:flappwritechat/models/message.dart';
import 'package:flappwritechat/services/api_service.dart';
import 'package:flappwritechat/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatWidget extends StatefulWidget {
  final Channel channel;

  const ChatWidget({Key? key, required this.channel}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  String? text;
  late TextEditingController _controller;
  late List<Message> messages;
  RealtimeSubscription? subscription;

  @override
  void didUpdateWidget(ChatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channel != widget.channel) init();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    _controller = TextEditingController();
    messages = widget.channel.messages.reversed.toList();
    try {
      subscription = ApiService.instance
          .subscribe("documents.${widget.channel.id}");

      subscription?.stream.listen((data) {
        if (data['payload'] != null) {
          setState(() {
            messages = Channel.fromMap(data['payload']).messages;
            messages = messages.reversed.toList();
          });
        }
      });
    } on AppwriteException catch (e) {
      print(e.message);
    }
    _controller.clear();
  }

  @override
  void dispose() {
    print("closing the connection ${widget.channel.title}");
    subscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          elevation: 0,
          title: Text(widget.channel.title),
        ),
        Expanded(
          child: ListView.separated(
            physics: BouncingScrollPhysics(),
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10.0);
            },
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              Message m = messages[index];
              if (m.senderId == context.read(userProvider).state?.id)
                return _buildMessageRow(m, current: true);
              return _buildMessageRow(m, current: false);
            },
          ),
        ),
        _buildBottomBar(context),
      ],
    );
  }

  Container _buildBottomBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: _controller,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  hintText: "Aa"),
              onEditingComplete: _save,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: _save,
          )
        ],
      ),
    );
  }

  _save() async {
    if (_controller.text.isEmpty) return;
    // FocusScope.of(context).requestFocus(FocusNode());
    final user = context.read(userProvider).state;
    try {
      await ApiService.instance.addMessage(
        data: {
          "content": _controller.text,
          "senderId": user?.id,
          "senderName": user?.name
        },
        channelId: widget.channel.id,
      );
      _controller.clear();
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  Row _buildMessageRow(Message message, {required bool current}) {
    return Row(
      mainAxisAlignment:
          current ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: current ? 30.0 : 20.0),

        ///Chat bubbles
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              bottom: 5,
              right: 5,
            ),
            child: Column(
              crossAxisAlignment:
                  current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(
                    minHeight: 40,
                    maxHeight: 250,
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                    minWidth: MediaQuery.of(context).size.width * 0.1,
                  ),
                  decoration: BoxDecoration(
                    color: current ? Colors.red : Colors.white,
                    borderRadius: current
                        ? BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )
                        : BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, top: 10, bottom: 5, right: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: current
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            message.content,
                            softWrap: true,
                            maxLines: 2,
                            style: TextStyle(
                              color: current ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  message.senderName,
                  style: TextStyle(
                      fontSize: 12, color: Colors.black.withOpacity(0.5)),
                )
              ],
            ),
          ),
        ),
        SizedBox(width: current ? 20.0 : 30.0),
      ],
    );
  }
}
