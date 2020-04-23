//import 'package:flutter/material.dart';
//import 'package:project1/screens/home/home.dart';
//import 'package:project1/screens/groups/joingroup.dart';
//import 'package:rflutter_alert/rflutter_alert.dart';
//
//class NewGroup extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('New Group'),
//        backgroundColor: Colors.brown[400],
//        elevation: 0.0,
//      ),
//      body: SafeArea(
//        child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Padding(
//              padding: const EdgeInsets.all(50.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  FlatButton(
//                    color: Colors.black,
//                    child: Text('Join Group',
//                    style: TextStyle(
//                      fontSize: 20.0,
//                      color: Colors.white,
//                    ),
//                    ),
//                    onPressed: () {
//                      Navigator.push<dynamic>(
//                          context,
//                          MaterialPageRoute<dynamic>(builder: (context) => JoinGroup()),
//                      );
//                    },
//           ),
//                ],
//              ),
//            ),
//            Padding(
//              padding: const EdgeInsets.all(50.0),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  FlatButton(
//                    color: Colors.black,
//                    child: Text('Create Group',
//                      style: TextStyle(
//                        fontSize: 20.0,
//                        color: Colors.white,
//                      ),
//                    ),
//                    onPressed: () {},
//                  ),
//                ],
//              ),
//            ),
//          ]
//        ),
//      ),
//    );
//  }
//}