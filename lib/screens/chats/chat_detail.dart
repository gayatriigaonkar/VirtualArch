import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chats_model.dart';
import '../../providers/chatsprovider.dart';
import '../../widgets/customloadingspinner.dart';
import '../../widgets/customscreen.dart';
import '../../widgets/headerwithphoto.dart';

class ChatDetail extends StatefulWidget {
  const ChatDetail({super.key});
  static const routeName = "/chatdetail";

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  late ChatsProvider chatsProvider;
  final _messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatsProvider = context.read<ChatsProvider>();
  }

  validateAndSendMessage(String message, bool read, Sender sender) {
    if (message.trim().isNotEmpty) {
      _messageTextController.clear();
      chatsProvider.sendMessage(
        message,
        true,
        Sender.user,
      );
      chatsProvider.getHiredArchitects("EGAy9SR4tvb4FyIwzJuKaZOcKIZ2");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    // final chatsProvider = Provider.of<ChatsProvider>(context, listen: true);
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MyCustomScreen(
          leftPadding: 0,
          rightPadding: 0,
          screenContent: Stack(
            children: [
              HeaderWithPhoto(
                heading: args['name'],
                screenToBeRendered: "None",
                imageURL: args['imageUrl'],
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.05),
                child: SizedBox(
                  height: size.height * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: StreamBuilder(
                      stream: chatsProvider.getChatStream("UserIdArchitectId"),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const CustomLoadingSpinner();
                        } else {
                          var listMessage = snapshot.data?.docs;
                          return ListView.builder(
                            itemCount: listMessage?.length,
                            //shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final message = listMessage?[index]['message'];
                              final sender = listMessage?[index]['sender'];
                              final time = listMessage?[index]['time'];
                              final read = listMessage?[index]['read'];
                              return Container(
                                // padding: const EdgeInsets.only(
                                //left: 14, right: 14, top: 10, bottom: 10),
                                padding: sender == "architect"
                                    ? const EdgeInsets.only(
                                        left: 0,
                                        right: 25,
                                        top: 10,
                                        bottom: 10,
                                      )
                                    : const EdgeInsets.only(
                                        left: 25,
                                        right: 0,
                                        top: 10,
                                        bottom: 10,
                                      ),
                                child: Align(
                                  alignment: (sender == "architect"
                                      ? Alignment.topLeft
                                      : Alignment.topRight),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: (sender == "architect"
                                          ? Theme.of(context).canvasColor
                                          : Theme.of(context).primaryColor),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      message,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).canvasColor.withOpacity(1),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageTextController,
                            decoration: const InputDecoration(
                              hintText: "Type a message.",
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.camera_alt_rounded,
                            color: Theme.of(context).secondaryHeaderColor,
                            size: 30,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            validateAndSendMessage(
                              _messageTextController.text,
                              true,
                              Sender.user,
                            );
                          },
                          icon: Icon(
                            Icons.send,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
