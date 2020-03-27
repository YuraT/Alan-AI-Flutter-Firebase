import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/models/user.dart';
import 'package:project1/models/user_data_model.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference usersCollection = Firestore.instance.collection("users");
  final CollectionReference usernamesCollection = Firestore.instance.collection("usernames");


  Future updateUserData(String firstName, String lastName, String username) async {
    return await usersCollection.document(uid).setData( {
      "firstName" : firstName,
      "lastName" : lastName,
      "username" : username,
    });
  }

  // user data model list from snapshot
  List<UserDataModel> _usersDataListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserDataModel(
        firstName: doc.data["firstName"] ?? '',
        lastName: doc.data["lastName"] ?? '',
        username: doc.data["username"] ?? '',
        );
    }).toList();
  }

  // get collection stream
  Stream<List<UserDataModel>> get users {
    return usersCollection.snapshots().map(_usersDataListFromSnapshot);
  }

  // currentUserData from snapshot
  CurrentUserData _currentUserDataFromSnapshot(DocumentSnapshot snapshot) {
    return CurrentUserData(
      uid: uid,
      firstName: snapshot.data["firstName"],
      lastName: snapshot.data["lastName"],
      username: snapshot.data["username"]
    );
  }

  Stream<CurrentUserData> get currentUserData {
    return usersCollection.document(uid).snapshots().map(_currentUserDataFromSnapshot);
  }
}