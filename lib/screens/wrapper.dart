import "package:flutter/material.dart";
import 'package:project1/models/user.dart';
import 'package:project1/screens/authenticate/authenticate.dart';
import 'package:project1/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    // return authenticate or home depending on user status
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}