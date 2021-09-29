import 'package:flappwritechat/services/api_service.dart';
import 'package:flappwritechat/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Card(
                    color: Colors.red,
                    margin: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    elevation: 10,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          SafeArea(
            child: ListView(
              children: [
                const SizedBox(height: 40.0),
                Text(
                  "Welcome",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.white,
                      ),
                ),
                Text(
                  "Awesome login Form",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 30.0),
                Card(
                  margin: const EdgeInsets.all(32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      const SizedBox(height: 20.0),
                      Text(
                        "Log In",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.red,
                            ),
                      ),
                      const SizedBox(height: 40.0),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Enter username",
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Enter password",
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      ElevatedButton(
                        child: Text("SUBMIT"),
                        onPressed: () async {
                          final loggedIn = await ApiService.instance.login(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          if (loggedIn) {
                            final user = await ApiService.instance.getUser();
                            context.read(userProvider).state = user;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16.0),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextButton(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, 'signup'),
        label: Text("Sign Up"),
        icon: Icon(Icons.arrow_forward),
      ),
    );
  }
}
