import 'dart:developer';

import 'package:chatter/database.dart';
import 'package:flutter/material.dart';
import 'package:chatter/pages/home_screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../auth.dart';
import '../user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String loginMessage = "";
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Column(
          children: [
            const SizedBox(height: 100),
            Container(
              alignment: Alignment.center,
              child: const Image(
                image: AssetImage("assets/y_logo.png"),
                height: 150,
                width: 150,
              ),
            ),
            const SizedBox(height: 40),

            const Text("Welcome Back",
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Lexend",
                    fontWeight: FontWeight.bold)),
            Container(
              margin: const EdgeInsets.only(
                top: 35,
                left: 25,
                right: 25,
              ),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Lexend",
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                left: 25,
                right: 25,
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Lexend",
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                ),
              ),
            ),
            //Make a sign in button inside a container which open the home screen
            Container(
                margin: const EdgeInsets.only(
                  top: 40,
                  left: 25,
                  right: 25,
                ),
                child: RoundedLoadingButton(
                    successIcon: Icons.check,
                    color: const Color.fromRGBO(69, 69, 69, 1),
                    borderRadius: 5,
                    controller: _buttonController,
                    onPressed: () async {
                      String email = _emailController.text.trim();
                      String password = _passwordController.text;
                      try {
                        await Auth().signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        String name = await Database().getName(email: email);
                        String status =
                            await Database().getStatus(email: email);
                        String avatarNumber =
                            await Database().getAvatarNumber(email: email);
                        User user = User(
                            name: name,
                            email: email,
                            status: status,
                            avatar: avatarNumber);
                        _buttonController.success();
                        await Future.delayed(const Duration(seconds: 1));
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return HomeScreen(currentUser: user);
                        })).then((value) => _buttonController.reset());
                      } catch (e) {
                        _buttonController.error();
                        setState(() {
                          loginMessage = "Invalid email or password";
                        });
                        await Future.delayed(const Duration(seconds: 2));
                        _buttonController.reset();
                        log(e.toString());
                      }
                    },
                    child: const Text("Sign in",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Lexend",
                        )))
                // ElevatedButton(
                //   onPressed: () async {
                //     String email = _emailController.text.trim();
                //     String password = _passwordController.text;
                //     try {
                //       await Auth().signInWithEmailAndPassword(
                //         email: email,
                //         password: password,
                //       );

                //       String name = await Database().getName(email: email);
                //       String status = await Database().getStatus(email: email);
                //       User user = User(name: name, email: email, status: status);

                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (context) {
                //         return HomeScreen(currentUser: user);
                //       }));
                //     } catch (e) {
                //       setState(() {
                //         loginMessage = "Invalid email or password";
                //       });
                //       log(e.toString());
                //     }
                //   },
                //   style: ElevatedButton.styleFrom(
                //     fixedSize: const Size(350, 50),
                //     backgroundColor: const Color.fromRGBO(69, 69, 69, 1),
                //     textStyle: const TextStyle(
                //       fontSize: 20,
                //       fontFamily: "Lexend",
                //     ),
                //   ),
                //   child: const Text("Sign In"),
                // ),
                ),

            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't Have An Account?",
                  style: TextStyle(
                    fontFamily: "Lexend",
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontFamily: "Lexend",
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    )),
              ],
            )),
            Text(loginMessage,
                style: const TextStyle(
                    color: Color.fromARGB(255, 219, 97, 89),
                    fontFamily: "Lexend",
                    fontSize: 18)),
          ],
        ));
  }
}
