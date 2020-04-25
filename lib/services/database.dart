import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project1/models/group_data_model.dart';
import 'package:project1/models/user.dart';
import 'package:project1/models/user_data_model.dart';

class DatabaseService {
  final String userUid;
  final String groupUid;
  DatabaseService({this.userUid, this.groupUid});

  // collection references
  final CollectionReference usersCollection = Firestore.instance.collection("users");
  final CollectionReference groupsCollection = Firestore.instance.collection("groups");
  final CollectionReference tasksCollection = Firestore.instance.collection("tasks");
  final CollectionReference invitesCollection = Firestore.instance.collection("invites");
  //final CollectionReference usernamesCollection = Firestore.instance.collection("usernames");
  // the usernames collection above was going to be used to have login with username, but I didn't get around to it
  
  // if there is already an invite with that group and user, return that. else create a new one
  Future<String> getGroupInvite(String user, String group) async {
    QuerySnapshot invites = await invitesCollection.where("creator", isEqualTo: user).where("group", isEqualTo: group).getDocuments();
    if (invites.documents.length > 0) return invites.documents.toList()[0].documentID;
    else return createGroupInvite(user, group);
  }
  Future<String> createGroupInvite(String user, String group) async {
    DocumentReference doc = invitesCollection.document();
    await doc.setData({
      "active": true,
      "creator": user,
      "group": group,
    });
    return doc.documentID;
  }
  Future joinGroup(String user, String inviteUid) async {
    return await invitesCollection.document(inviteUid).get().then((doc) { 
      if (doc.exists == false) {
        throw "invite code does not exist";
        }
      groupsCollection.document(doc.data["group"]).updateData({
        "users": FieldValue.arrayUnion([user])
      });
    });
  }
  Future createGroup(String groupName, List<String> admins, List<String> users) {
    return groupsCollection.document().setData({
      "name": groupName,
      "admins": admins,
      "users": users,
    });
  }


  Future createTask(String title, String description, String group, String assigner, List<String> users, DateTime deadline, bool completedStatus) async {
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

  Future updateUserData(String firstName, String lastName, String username) async {
    return await usersCollection.document(userUid).setData( {
      "firstName" : firstName,
      "lastName" : lastName,
      "username" : username,
    });
  }

  // user data model list from snapshot
  List<UserDataModel> _usersDataListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return UserDataModel(
        uid: doc.documentID ?? '',
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
        uid: doc.documentID,
        name: doc.data["name"],
        users: List.from(doc.data["users"]),
        admins: List.from(doc.data["admins"]),
      );
    }).toList();
  }
  // get collection stream for group collection
  Stream<List<GroupDataModel>> get groups {
    // its good to know that if uid == null, the where method just wont do anything
    return groupsCollection.where("users", arrayContains: userUid).snapshots().map(_groupsDataListFromSnapshot);
  }
  Future<List<GroupDataModel>> get groupsSnapshot async {
    return await groupsCollection.where("users", arrayContains: userUid).getDocuments().then(_groupsDataListFromSnapshot);
  }

  // task data model list from snapshot
  List<TaskDataModel> _tasksListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return TaskDataModel(
        title: doc.data["title"],
        description: doc.data["description"],
        assigner: doc.data["assigner"],
        users: List.from(doc.data["users"]),
        deadline: /*DateTime.utc(2020, 4, 26, 14, 0),*/doc.data["deadline"].toDate(),
        completedStatus: doc.data["completedStatus"],
      );
    }).toList();
  }
  // get collection stream for tasks, where group is equal to provided group uid (if it is provided)
  Stream<List<TaskDataModel>> get tasks {
    return tasksCollection.where("group", isEqualTo: groupUid).where("users", arrayContains: userUid).snapshots().map(_tasksListFromSnapshot);
  }

  // currentUserData from snapshot
  CurrentUserData _currentUserDataFromSnapshot(DocumentSnapshot documentSnapshot) {
    //print("tasks reference:   " + snapshot.data["tasks"]); // doesn't work yet
    return CurrentUserData(
      uid: userUid,
      // the tasks stuff in this function was inteded to provide a list of tasks specific to current user
      // Im not sure if I will keep this stuff here or find a different way to do it
      //tasks: _tasksListFromSnapshot(snapshot), // doesn't work yet either
      //tasks: [TaskDataModel(title: "task1", description: "desc1", deadline: DateTime.utc(2020, 4, 26, 14, 0)), TaskDataModel(title: "task2", description: "desc2", deadline: DateTime.utc(2020, 4, 19, 14, 0))],
      //tasks: List.from(documentSnapshot.data["tasks"]),
      // holy crap all of that is absolute trash but Ill leave it there just in case I decide to use it later
      firstName: documentSnapshot.data["firstName"],
      lastName: documentSnapshot.data["lastName"],
      username: documentSnapshot.data["username"]
    );
  }
  Stream<CurrentUserData> get currentUserData {
    return usersCollection.document(userUid).snapshots().map(_currentUserDataFromSnapshot);
  }

}