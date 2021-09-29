import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:flappwritechat/models/channel.dart';
import 'package:flappwritechat/pages/chat_page.dart';
import 'package:flappwritechat/pages/login.dart';
import 'package:flappwritechat/pages/profile.dart';
import 'package:flappwritechat/pages/home.dart';
import 'package:flappwritechat/pages/signup.dart';
import 'package:flappwritechat/services/api_service.dart';
import 'package:flappwritechat/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Counter(),
      ),
    );
  }
}

class Counter extends StatefulWidget {
  Counter({Key? key}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  late Account account;
  late Realtime realtime;
  Client client = Client();
  void _incrementCounter() async {
    try {
      final res = await account.createSession(
          email: 'user@example.com', password: 'password');
      print(res);
      RealtimeSubscription sub = realtime.subscribe(['collections']);
      print('Got Sub');
      sub.stream.listen((event) {
        print(event);
      });
      setState(() {});
    } on AppwriteException catch (e) {
      print(e.message);
    }
  }

  @override
  void initState() {
    client.setEndpoint('http://192.168.1.64/v1').setProject('60ec2bb7229ff');
    realtime = Realtime(client);
    account = Account(client);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hello"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _incrementCounter,
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  _getUser() async {
    final user = await ApiService.instance.getUser();
    if (user != null) {
      context.read(userProvider).state = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthChecker(),
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) {
          switch (settings.name) {
            case 'login':
              return LoginPage();
            case 'signup':
              return SignupPage();
            case 'profile':
              return ProfilePage();
            case 'chat':
            default:
              return ChatPage(
                channel: settings.arguments as Channel,
              );
          }
        });
      },
    );
  }
}

class AuthChecker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isLoggedIn = watch(userProvider).state != null;
    return isLoggedIn ? HomePage() : LoginPage();
  }
}
