import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../firebase/authentication.dart';
import '../../screens/chats/chat_detail.dart';

class ChatList extends StatefulWidget {
  final String clientsName;
  final String architectsName;
  final String message;
  final String imageUrl;
  final String time;
  final int unreadCount;
  final bool isRead;
  final String chatsId;
  final String clientsEmail;
  const ChatList({
    super.key,
    required this.clientsName,
    required this.architectsName,
    required this.message,
    required this.imageUrl,
    required this.time,
    required this.unreadCount,
    required this.chatsId,
    required this.isRead,
    required this.clientsEmail,
  });
  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print(widget.imageUrl);

    return InkWell(
      onTap: () {
        final User? architect = Auth().currentUser;
        Navigator.of(context).pushNamed(ChatDetail.routeName, arguments: {
          'aid': architect!.uid,
          'uid': widget.chatsId.replaceAll(architect.uid, ""),
          'clientsName': widget.clientsName,
          'imageUrl': widget.imageUrl,
          'clientsEmail': widget.clientsEmail,
          'chatsId': widget.chatsId,
          'architectsName': widget.architectsName,
        });
      },
      splashColor: Theme.of(context).primaryColor,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Stack(
                // overflow: Overflow.visible,
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(6.5, 0, 0, 0),
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(widget.imageUrl, scale: 0.4),
                      maxRadius: 30,
                    ),
                  ),
                  Positioned(
                      left: 0,
                      bottom: -8,
                      child: Container(
                        height: 18,
                        width: 75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColor,
                        ),
                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                        child: Text(
                          "Client",
                          // "Hired",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                color: Theme.of(context).secondaryHeaderColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(
              width: size.width * 0.06,
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          child: Text(
                            widget.clientsName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Text(
                          widget.time.toString(),
                          textAlign: TextAlign.right,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    // color: Theme.of(context).canvasColor,
                                    // color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  )),
                  SizedBox(
                    height: size.height * 0.009,
                  ),
                  Text(
                    widget.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: widget.isRead
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
