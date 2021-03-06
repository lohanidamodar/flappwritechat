import 'package:flappwritechat/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: watch(channelsProvider).when(
        data: (channels) {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: channels.length,
            itemBuilder: (context,index) {
              final channel = channels[index];
              return ListTile(
                title: Text(channel.title),
                onTap: () => Navigator.pushNamed(context, 'chat', arguments: channel),
              );
            },
          );
        },
        loading: () => CircularProgressIndicator(),
        error: (e, s) {
          print(e);
          print(s);
          return Container(
          child: Text("There is an error"),
        );
        },
      ),
    );
  }
}
