import 'package:cloud_firestore/cloud_firestore.dart';

class Datastore {
  getUser(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get();
  }

  Future addTextsFirebase(
      String chatroomID, String textID, Map textInfo) async {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .collection("texts")
        .doc(textID)
        .set(textInfo);
  }

  updateLastSendText(String chatroomID, Map lastTextInfo) {
    return FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .update(lastTextInfo);
  }

  createChatRoom(String chatroomID, Map chatRoomInfo) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatroomID)
        .get();
    if (snapShot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(chatroomID)
          .set(chatRoomInfo);
    }
  }

  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e.toString());
    });
  }
}