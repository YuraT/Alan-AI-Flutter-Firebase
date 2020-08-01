import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final DocumentReference ref;
  User({this.ref});
  static DocumentReference refFromUid(String uid) {
    return Firestore.instance.collection("users").document(uid);
  }
}
