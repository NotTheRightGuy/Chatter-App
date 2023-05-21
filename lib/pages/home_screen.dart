import 'package:chatter/user.dart';
import 'package:flutter/material.dart';
import 'chat_room.dart';

class HomeScreen extends StatefulWidget {
  final User currentUser;
  const HomeScreen({super.key, required this.currentUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User get user => widget.currentUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 30, top: 10),
                child: const Image(
                  image: AssetImage('assets/x_logo.png'),
                  height: 60,
                  width: 120,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            AssetImage('assets/avatars/${user.avatar}.png'),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            user.name,
                            style: const TextStyle(
                                fontFamily: "Lexend",
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width * 0.7,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Opacity(
                            opacity: 0.5,
                            child: Text(
                              user.status,
                              style: const TextStyle(
                                  fontFamily: "Lexend",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.centerLeft,
                child: const Text("Chats",
                    style: TextStyle(
                        fontFamily: "Lexend",
                        fontSize: 36,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Color.fromRGBO(69, 69, 69, 1),
                thickness: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.arrow_right_alt_rounded,
                          color: Colors.white,
                        ),
                      ),
                      hintText: "Already Got A Room? Enter Room Code (WIP)",
                      hintStyle: TextStyle(
                          fontFamily: "Lexend",
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5)),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(69, 69, 69, 1)))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatRoomScreen(
                            user: user,
                          )));
            },
            backgroundColor: const Color.fromRGBO(69, 69, 69, 1),
            child: const Icon(
              Icons.add,
              size: 30,
            ),
          )),
    );
  }
}
