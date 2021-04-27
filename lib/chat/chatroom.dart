import 'package:chat_app/chat/chatscreen.dart';
import 'package:chat_app/registration/datastore.dart';
import 'package:chat_app/registration/signIN.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      body: WillPopScope(
        onWillPop: () {
          SystemNavigator.pop();
        },
        child: Stack(
          children: [
            Container(
                height: double.infinity,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 45,
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                              color: Colors.deepOrange[900],
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Logged In",
                          style: TextStyle(
                              color: Colors.deepOrange[400],
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {},
                      color: Colors.deepOrange[900],
                    )
                  ],
                )),
            Positioned(
                top: 120,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.deepOrange[200],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.deepOrange[900],
                              ),
                            );
                          }
                          return ListView(
                            children: snapshot.data.docs.map((Document) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        var chatroomID = getchatroomID(
                                            user.email, Document["userEmail"]);
                                        Map<String, dynamic> chatRoomInfo = {
                                          "users": [
                                            user.email,
                                            Document["userEmail"]
                                          ]
                                        };
                                        Datastore().createChatRoom(
                                            chatroomID, chatRoomInfo);

                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) => ChatFinal(
                                                    Document["userEmail"])));
                                      },
                                      child: Container(
                                          height: 50,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Colors.deepOrange[50],
                                                Colors.deepOrange[600]
                                              ]),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
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
                                                color: Colors.deepOrange[900],
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        })))
          ],
        ),
      ),
    );
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    await auth.signOut();
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
  }
}
