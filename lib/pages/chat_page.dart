import 'package:flappwritechat/models/channel.dart';
import 'package:flutter/material.dart'; 

class ChatPage extends StatelessWidget {
  final Channel channel;

  const ChatPage({Key key, this.channel}) : super(key: key);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Page'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: channel.messages.length,
        itemBuilder: (context,index) {
          final message = channel.messages[index];
          return ListTile(title: Text(message.content),);
        },
      ),
    );
  }
}