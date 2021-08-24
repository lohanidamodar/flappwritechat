/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */

import 'package:flappwritechat/models/channel.dart';
import 'package:flappwritechat/widgets/chat_widget.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final Channel channel;

  const ChatPage({Key? key, required this.channel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatWidget(
        channel: channel,
      ),
    );
  }
}
