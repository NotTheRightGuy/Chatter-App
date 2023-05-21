import 'dart:developer';
import 'package:chatter/message.dart';
import 'package:chatter/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

String formatTime(DateTime dateTime) {
  final timeFormat = DateFormat('h:mm a');
  final formattedTime = timeFormat.format(dateTime);
  return formattedTime;
}

class ChatRoomScreen extends StatefulWidget {
  final User user;
  const ChatRoomScreen({super.key, required this.user});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

late IO.Socket socket;
List<Message> messages = [];

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  User get user => widget.user;
  String uri = "https://chatter-server.talkingaboutabout.repl.co";
  String chatRoomName = "Existential Crisis";
  String chatRoomId = "XXX420";

  var fieldController = TextEditingController();
  final ScrollController _controller = ScrollController();

  void scrollToBottom() {
    _controller.animateTo(_controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  void initState() {
    initSocket();
    super.initState();
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  initSocket() {
    socket = IO.io(uri, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();
    socket.onConnect((_) {
      log('${user.name} connected With ID : ${socket.id}');
      socket.emit('join', user.name);
    });
    socket.onDisconnect((data) async {
      log('Disconnected');
    });
    socket.onConnectError((err) => log("Connection Error"));
    socket.onConnectTimeout((err) => log("Connection Timeout"));
    socket.onError((err) => log("Error"));

    socket.on("message", (data) {
      setState(() {
        messages.add(Message(
            text: data['message'], sender: data['sender'], time: data['time']));
        scrollToBottom();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Column(
            children: [
              Container(
                  // *Top Bar
                  height: 45,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            chatRoomName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Opacity(
                            opacity: 0.6,
                            child: Text(chatRoomId,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          )
                        ],
                      ),
                    ],
                  )),
              const Divider(
                color: Colors.white,
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              controller: _controller,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Align(
                    alignment: messages[index].sender == user.name
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: messages[index].sender == user.name
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Opacity(
                          opacity: 0.7,
                          child: Text(
                            messages[index].sender,
                            style: const TextStyle(
                                fontSize: 12, fontFamily: "Lexend"),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                              color: messages[index].sender == user.name
                                  ? const Color.fromRGBO(115, 176, 101, 1)
                                  : const Color.fromRGBO(255, 173, 8, 1),
                              borderRadius: messages[index].sender == user.name
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(6),
                                      bottomLeft: Radius.circular(6),
                                      bottomRight: Radius.circular(6),
                                    )
                                  : const BorderRadius.only(
                                      topRight: Radius.circular(6),
                                      bottomLeft: Radius.circular(6),
                                      bottomRight: Radius.circular(6),
                                    )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                messages[index].text,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Opacity(
                          opacity: 0.7,
                          child: Text(
                            messages[index].time,
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // *Bottom Bar which has a text field and a send button make it such that it is always visible even when keyboard is open

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            left: 10,
            right: 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(51, 51, 51, 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: fieldController,
                        decoration: const InputDecoration(
                          hintText: "Type a message",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) => {
                          if (value.isNotEmpty)
                            {
                              setState(() {
                                messages.add(Message(
                                    text: value,
                                    sender: user.name,
                                    time: formatTime(DateTime.now())));
                                socket.emit('message', {
                                  'message': value,
                                  'sender': user.name,
                                  'time': formatTime(DateTime.now()),
                                });
                                fieldController.clear();
                                scrollToBottom();
                              })
                            }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(115, 176, 101, 1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (fieldController.text.isNotEmpty) {
                      setState(() {
                        messages.add(Message(
                            text: fieldController.text,
                            sender: user.name,
                            time: formatTime(DateTime.now())));
                        socket.emit('message', {
                          'message': fieldController.text,
                          'sender': user.name,
                          'time': formatTime(DateTime.now()),
                        });
                        fieldController.clear();
                        scrollToBottom();
                      });
                    }
                  },
                )),
          ],
        ),
      ),
    ));
  }
}
