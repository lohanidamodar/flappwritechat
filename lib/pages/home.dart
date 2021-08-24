import 'package:flappwritechat/models/channel.dart';
import 'package:flappwritechat/widgets/channels_list.dart';
import 'package:flappwritechat/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Channel? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, 'profile'),
          ),
        ],
      ), */
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          if (sizingInformation.deviceScreenType == DeviceScreenType.desktop ||
              sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
            return Row(
              children: [
                SizedBox(
                  width: 350,
                  child: Ink(
                    color: Colors.grey.shade200,
                    child: ChannelsList(
                      onTapChannel: (channel) {
                        setState(() {
                          _selected = channel;
                        });
                      },
                      selectedChannel: _selected,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: _selected != null
                        ? ChatWidget(channel: _selected!)
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                                child:
                                    Text("Select a channel to begin chatting")),
                          ),
                  ),
                )
              ],
            );
          }
          return ChannelsList(
            onTapChannel: (channel) =>
                Navigator.pushNamed(context, 'chat', arguments: channel),
          );
        },
      ),
    );
  }
}
