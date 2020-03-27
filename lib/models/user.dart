class User {
  final String uid;
  User({this.uid});
}

class CurrentUserData {

  final String uid;
  final String firstName;
  final String lastName;
  final String username;

  CurrentUserData({this.uid, this.firstName, this.lastName, this.username});
}