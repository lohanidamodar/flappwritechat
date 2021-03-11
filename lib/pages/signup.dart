import 'package:flappwritechat/services/api_service.dart';
import 'package:flappwritechat/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailControllerProvider =
    Provider<TextEditingController>((ref) => TextEditingController());
final passwordControllerProvider =
    Provider<TextEditingController>((ref) => TextEditingController());
final nameControllerProvider =
    Provider<TextEditingController>((ref) => TextEditingController());

class SignupPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
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
                  style: Theme.of(context).textTheme.headline3.copyWith(
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
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.red,
                            ),
                      ),
                      const SizedBox(height: 40.0),
                      TextField(
                        controller: watch(nameControllerProvider),
                        decoration: InputDecoration(
                          labelText: "Enter name",
                        ),
                      ),
                      TextField(
                        controller: watch(emailControllerProvider),
                        decoration: InputDecoration(
                          labelText: "Enter username",
                        ),
                      ),
                      TextField(
                        controller: watch(passwordControllerProvider),
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
                              email: context.read(emailControllerProvider).text,
                              password: context
                                  .read(passwordControllerProvider)
                                  .text);
                          if (loggedIn) {
                            final user = await ApiService.instance.getUser();
                            context.read(userProvider).state = user;
                            context.read(isLoggedInProvider).state = true;
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
