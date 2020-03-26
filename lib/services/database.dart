import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/models/user.dart';
import 'package:project1/models/user_data_model.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference usersCollection = Firestore.instance.collection("users");

  Future updateUserData(String sugars, String name, int strength) async {
    return await usersCollection.document(uid).setData( {
      "sugars" : sugars,
      "name" : name,
      "strength" : strength,
    });
  }

  // user data model list from snapshot
  List<UserDataModel> _usersDataListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserDataModel(
        name: doc.data["name"] ?? '',
        strength: doc.data["strength"] ?? '',
        sugars: doc.data["sugars"] ?? 0
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
      name: snapshot.data["name"],
      strength: snapshot.data["strength"],
      sugars: snapshot.data["sugars"]
    );
  }

  Stream<CurrentUserData> get currentUserData {
    return usersCollection.document(uid).snapshots().map(_currentUserDataFromSnapshot);
  }
}