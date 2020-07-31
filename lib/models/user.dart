import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final DocumentReference ref;
  User({this.ref});
  static DocumentReference refFromUid(String uid) {
    return Firestore.instance.collection("users").document(uid);
  }
}

class CurrentUserData {

  final String uid;
  final List<String> tasks;
  final String firstName;
  final String lastName;
  final String username;

  CurrentUserData({this.uid, this.tasks, this.firstName, this.lastName, this.username});
}
