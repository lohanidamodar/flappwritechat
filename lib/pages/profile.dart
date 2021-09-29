import 'package:flappwritechat/services/api_service.dart';
import 'package:flappwritechat/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            title: Text("Logout"),
            leading: Icon(Icons.exit_to_app),
            onTap: () async {
              await ApiService.instance.logout();
              context.read(userProvider).state = null;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}