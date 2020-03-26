class User {
  final String uid;
  User({this.uid});
}

class CurrentUserData {

  final String uid;
  final String name;
  final int strength;
  final String sugars;

  CurrentUserData({this.uid, this.name, this.strength, this.sugars});
}