import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../auth.dart';
import '../database.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RoundedLoadingButtonController _buttonController =
      RoundedLoadingButtonController();
  late String signUpMessage = "";

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
            const Text("Let's Get Started",
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
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: "Full Name",
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
            Container(
              margin: const EdgeInsets.only(
                top: 40,
                left: 25,
                right: 25,
              ),
              child: RoundedLoadingButton(
                color: const Color.fromRGBO(69, 69, 69, 1),
                controller: _buttonController,
                onPressed: () async {
                  try {
                    await Auth().createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    await Database().createNewUser(
                      name: _nameController.text,
                      email: _emailController.text,
                    );
                    _buttonController.success();
                    await Future.delayed(const Duration(seconds: 1));
                    Navigator.pushReplacementNamed(context, "/login");
                    _buttonController.reset();
                  } catch (e) {
                    setState(() {
                      signUpMessage = "Email Already In Use";
                    });
                    _buttonController.error();
                    await Future.delayed(const Duration(seconds: 1));
                    _buttonController.reset();
                    log(e.toString());
                  }
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontFamily: "Lexend",
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already Have An Account?",
                  style: TextStyle(
                    fontFamily: "Lexend",
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                TextButton(
                    onPressed: () async {
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontFamily: "Lexend",
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ))
              ],
            )),
            Text(signUpMessage,
                style: const TextStyle(
                    color: Colors.red, fontSize: 14, fontFamily: "Lexend"))
          ],
        ));
  }
}
