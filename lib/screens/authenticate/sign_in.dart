import "package:flutter/material.dart";
import 'package:project1/services/auth.dart';
import 'package:project1/shared/constants.dart';
import 'package:project1/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  
  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color.fromARGB(255, 229, 235, 239),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10.0,
        //title: Image.asset('assets/images/TaskEaseSignIn.png', fit: BoxFit.contain, height: 40,),
 
        /*Text(
          "TaskEase",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color.fromARGB(255, 58, 83, 115),
            fontSize: 30,
            letterSpacing: 2
          ),
          ),
          */
        actions: <Widget>[
          FlatButton.icon(onPressed: () {
            widget.toggleView();
          }, 
          icon: Icon(Icons.person), 
          label: Text("Register"))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal:50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Image.asset('assets/images/TaskEase.png'),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Email"),
                validator: (val) => val.isEmpty ? "Enter an email" : null,
                onChanged: (val) {
                  setState(() => email = val);
                }
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: "Password"),
                validator: (val) => val.length < 6 ? "Enter a password 6+ symbols long" : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                }
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Color.fromARGB(255, 58, 83, 115),
                child: Text("Sign in", style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                    if (result == null) {
                      setState(() { 
                        error = 'problem signing in';
                        loading = false;
                        });
                      print(error);
                    }
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0)),
            ],
          ),
        )
        // anon sign in button
        /*child: RaisedButton(
          child: Text("Sign in"),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if (result == null) {
              print("error signing in");
            } else {
              print("signed in");
              print(result.uid);
            }
          },
        ),*/
        ),
    );
  }
}