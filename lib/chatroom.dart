import 'package:chat_app/registration/signIN.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Chat App"),
        actions: [
          InkWell(
            onTap: () {
              logout().whenComplete(() => Navigator.pop(context));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Icon(Icons.exit_to_app_rounded),
            ),
          )
        ],
        backgroundColor: Colors.teal[700],
      ),
    );
  }

  Future logout() async {
    await auth.signOut();
  }
}
