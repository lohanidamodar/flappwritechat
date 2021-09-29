import 'package:flappwritechat/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
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
                  "Login Form",
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
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              color: Colors.red,
                            ),
                      ),
                      const SizedBox(height: 40.0),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Enter name",
                        ),
                      ),
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
                          final signedUp = await ApiService.instance.signup(
                            name: _nameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          if (signedUp) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Signup successful. Login now")));
                            Navigator.pop(context);
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
    );
  }
}
