import 'package:flutter/material.dart';
import 'package:chatter/pages/home_screen.dart';
import '../auth.dart';
import 'dart:async';
import '../user.dart';
import '../database.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () async {
      if (Auth().currentUser == null) {
        Navigator.pushReplacementNamed(context, "/login");
      } else {
        String email = Auth().currentUser!.email!;
        String name = await Database().getName(email: email);
        String status = await Database().getStatus(email: email);
        String avatar = await Database().getAvatarNumber(email: email);
        User user =
            User(name: name, email: email, status: status, avatar: avatar);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen(currentUser: user);
        }));
      }
    });
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image(image: AssetImage("assets/x_logo.png")),
      ),
    );
  }
}
