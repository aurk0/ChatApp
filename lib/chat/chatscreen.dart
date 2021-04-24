import 'package:chat_app/chat/chatroom.dart';
import 'package:chat_app/registration/datastore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class ChatFinal extends StatefulWidget {
  final String barName;
  ChatFinal(this.barName);
  @override
  _ChatFinalState createState() => _ChatFinalState();
}

class _ChatFinalState extends State<ChatFinal> {
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController textController = new TextEditingController();

  String chatroomID, textID;

  getInfo() async {
    chatroomID = getchatroomID(widget.barName, user.email);
  }

  getchatroomID(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  addText(bool sendClicked) {
    if (textController.text != "") {
      String texts = textController.text;
      var lastTexttime = DateTime.now();

      Map<String, dynamic> textInfo = {
        "texts": texts,
        "sender": user.email,
        "timeStand": lastTexttime
      };
      if (textID == "") {
        textID = randomAlphaNumeric(12);
      }
      Datastore().addTextsFirebase(chatroomID, textID, textInfo).then((value) {
        Map<String, dynamic> lastTextInfo = {
          "lastText": texts,
          "lastTextTime": lastTexttime,
          "lastTextSender": user.email
        };
        Datastore().updateLastSendText(chatroomID, lastTextInfo);
        if (sendClicked) {
          textController.text = "";
          textID = "";
        }
      });
    }
  }

  getsetTexts() {}

  doOnlaunch() async {
    await getInfo();
    getsetTexts();
  }

  @override
  void initState() {
    doOnlaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.barName), backgroundColor: Colors.teal[700]),
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.teal[700],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            hintText: "type your text",
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            addText(true);
                          })
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
