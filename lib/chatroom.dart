import 'package:chat_app/registration/datastore.dart';
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
                        child: Container(
                            height: 45,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.blue, Colors.amberAccent]),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  Document["userEmail"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.message,
                                      color: Colors.blueGrey[800],
                                    ),
                                    onPressed: () {})
                              ],
                            )),
                      ),
                    ],
                  );
                }).toList(),
              );
            }));
  }

  Future logout() async {
    await auth.signOut();
  }
}
