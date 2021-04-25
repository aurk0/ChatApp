import 'package:chat_app/chat/chatscreen.dart';
import 'package:chat_app/registration/datastore.dart';
import 'package:chat_app/registration/signIN.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Datastore datastore = new Datastore();
  FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  getchatroomID(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

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
                logout();
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Icon(Icons.exit_to_app_rounded),
              ),
            )
          ],
          backgroundColor: Colors.teal[700],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                children: snapshot.data.docs.map((Document) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            var chatroomID = getchatroomID(
                                user.email, Document["userEmail"]);
                            Map<String, dynamic> chatRoomInfo = {
                              "users": [user.email, Document["userEmail"]]
                            };
                            Datastore()
                                .createChatRoom(chatroomID, chatRoomInfo);

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChatFinal(Document["userEmail"])));
                          },
                          child: Container(
                              height: 45,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.blue,
                                    Colors.amberAccent
                                  ]),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    Document["userEmail"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Icon(
                                    Icons.message,
                                    color: Colors.blueGrey[800],
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              );
            }));
  }

  Future logout() async {
    await auth.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
  }
}
