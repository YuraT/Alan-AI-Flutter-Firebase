import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/task_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/models/user_data_model.dart';
class DatabaseService {
  final DocumentReference userRef;
  final DocumentReference groupRef;
  DatabaseService({this.userRef, this.groupRef});

  // collection references
  final CollectionReference usersCollection = Firestore.instance.collection("users");
  final CollectionReference groupsCollection = Firestore.instance.collection("groups");
  final CollectionReference tasksCollection = Firestore.instance.collection("tasks");
  final CollectionReference invitesCollection = Firestore.instance.collection("invites");
  //final CollectionReference usernamesCollection = Firestore.instance.collection("usernames");
  // the usernames collection above was going to be used to have login with username, but I didn't get around to it
  
  // if there is already an invite with that group and user, return that. else create a new one
  Future<String> getGroupInvite(DocumentReference user, DocumentReference group) async {
    QuerySnapshot invites = await invitesCollection.where("creator", isEqualTo: user).where("group", isEqualTo: group).getDocuments();
    if (invites.documents.length > 0) return invites.documents.toList()[0].documentID;
    else return createGroupInvite(user, group);
  }
  Future<String> createGroupInvite(DocumentReference user, DocumentReference group) async {
    DocumentReference doc = invitesCollection.document();
    await doc.setData({
      "active": true,
      "creator": user,
      "group": group,
    });
    return doc.documentID;
  }
  Future joinGroup(DocumentReference user, String inviteUid) async {
    return await invitesCollection.document(inviteUid).get().then((doc) async { 
      if (doc.exists == false) {
        throw Exception("invite code does not exist");
      }
      
      await groupsCollection.document(doc.data["group"].documentID).updateData({
        "users": FieldValue.arrayUnion([user])
      });
    });
  }
  Future createGroup(String groupName, List<DocumentReference> admins, List<DocumentReference> users) {
    return groupsCollection.document().setData({
      "name": groupName,
      "admins": admins,
      "users": users,
    });
  }
  Future updateGroupData(DocumentReference groupRef, Map<String, dynamic> updates) {
    try {
      return groupRef.updateData(updates);
    } catch (e) {
      print(e.toString());
    }
  } 

  Future createTask(String title, String description, DocumentReference group, DocumentReference assigner, List<DocumentReference> users, DateTime deadline, bool completedStatus) async {
    try{ 
      return tasksCollection.document().setData({
      "title": title,
      "description": description,
      "group": group,
      "assigner": assigner,
      "users": users,
      "deadline": deadline,
      "completedStatus": completedStatus,
      });
    } catch (e) {
      print(e.toString());
    }
  }
  Future updateTaskData(DocumentReference taskRef, Map<String, dynamic> updates) {
    try {
      return taskRef.updateData(updates);
    } catch (e) {
      print(e.toString());
    }
  } 

  Future updateUserData(String firstName, String lastName, String username) async {
    return await userRef.setData( {
      "firstName" : firstName,
      "lastName" : lastName,
      "username" : username,
    });
  }

  // user data model list from snapshot
  List<UserDataModel> _usersDataListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserDataModel(
        ref: doc.reference ?? '',
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

  // group data model list from snsapshot
  List<GroupDataModel> _groupsDataListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return GroupDataModel(
        ref: doc.reference,
        name: doc.data["name"],
        users: List.from(doc.data["users"]),
        admins: List.from(doc.data["admins"]),
      );
    }).toList();
  }
  // get collection stream for group collection
  Stream<List<GroupDataModel>> get groups {
    // its good to know that if uid == null, the where method just wont do anything
    return groupsCollection.where("users", arrayContains: userRef).snapshots().map(_groupsDataListFromSnapshot);
  }

  // task data model list from snapshot
  List<TaskDataModel> _tasksListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return TaskDataModel(
        ref: doc.reference,
        title: doc.data["title"],
        description: doc.data["description"],
        group: doc.data["group"],
        assigner: doc.data["assigner"],
        users: List.from(doc.data["users"]),
        deadline: doc.data["deadline"].toDate(),
        completedStatus: doc.data["completedStatus"],
      );
    }).toList();
  }
  // get collection stream for tasks, where group is equal to provided group uid (if it is provided)
  Stream<List<TaskDataModel>> get tasks {
    return tasksCollection.snapshots().map(_tasksListFromSnapshot);
  }

  // currentUserData from snapshot
  CurrentUserData _currentUserDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    return CurrentUserData(
      // get rid of this later
      uid: userRef.toString(),
      firstName: documentSnapshot.data["firstName"],
      lastName: documentSnapshot.data["lastName"],
      username: documentSnapshot.data["username"]
    );
  }
  Stream<CurrentUserData> get currentUserData {
    return userRef.snapshots().map(_currentUserDataFromSnapshot);
  }

}