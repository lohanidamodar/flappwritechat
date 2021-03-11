/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */
import 'dart:convert';
import 'package:flappwritechat/models/channel.dart';
import 'package:flappwritechat/models/message.dart';
import 'package:flappwritechat/services/api_service.dart';
import 'package:flappwritechat/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:websok/websok.dart';

class ChatPage extends StatefulWidget {
  final Channel channel;

  const ChatPage({Key key, this.channel}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String text;
  TextEditingController _controller;
  List<Message> messages;
  Websok sok;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    messages = widget.channel.messages.reversed.toList();
    sok = ApiService.instance.realTimeChannels(widget.channel.id);
    sok.listen(onData: (data) {
      print(data);
      data = json.decode(data);
      if (data['payload'] != null) {
        setState(() {
          messages = Channel.fromMap(data['payload']).messages;
          messages = messages.reversed.toList();
        });
      }
    });
    _controller.clear();
  }

  @override
  void dispose() {
    if (sok?.isActive ?? false) {
      sok.close(1000);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channel.title),
      ),
      body: Column(
        children: <Widget>[
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
                if (m.senderId == context.read(userProvider).state.id)
                  return _buildMessageRow(m, current: true);
                return _buildMessageRow(m, current: false);
              },
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
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
    FocusScope.of(context).requestFocus(FocusNode());
    final user = context.read(userProvider).state;
    await ApiService.instance.addMessage(
      data: {
        "content": _controller.text,
        "senderId": user.id,
        "senderName": user.name
      },
      channelId: widget.channel.id,
    );
    _controller.clear();
  }

  Row _buildMessageRow(Message message, {bool current}) {
    return Row(
      mainAxisAlignment:
          current ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: current ? 30.0 : 20.0),
        ///Chat bubbles
        Container(
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
                          style: TextStyle(
                            color: current ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.done_all,
                        color: Colors.white,
                        size: 14,
                      )
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
        SizedBox(width: current ? 20.0 : 30.0),
      ],
    );
  }
}
