import 'package:flappwritechat/services/api_service.dart';
import 'package:flappwritechat/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final titleControllerProvider = Provider((ref) => TextEditingController());

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    watch(channelsFutureProvider);
    var channels = watch(channelsProvider).state;
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
                controller: watch(titleControllerProvider),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    final channel = await ApiService.instance
                        .addChannel(context.read(titleControllerProvider).text);
                    if (channel != null) {
                      final cp = context.read(channelsProvider);
                      final channels = cp.state;
                      channels.add(channel);
                      cp.state = channels;
                    }
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
