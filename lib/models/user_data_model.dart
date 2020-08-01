import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  final DocumentReference ref;
  final String firstName;
  final String lastName;
  final String username;

  UserDataModel({this.ref, this.firstName, this.lastName, this.username});

  Map toJson() {
    return {
      "uid": this.ref.documentID,
      "firstName": this.firstName,
      "lastName": this.lastName,
      "username": this.username,
    };
  }
}
