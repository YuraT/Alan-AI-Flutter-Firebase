import "package:flutter/material.dart";
import 'package:project1/services/auth.dart';
import 'package:project1/shared/constants.dart';
import 'package:project1/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String firstName = '';
  String lastName = '';
  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';
  
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text("Sign up to App"),
        actions: <Widget>[
          FlatButton.icon(onPressed: () {
            widget.toggleView();
          }, 
          icon: Icon(Icons.person), 
          label: Text("Sign In"))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal:50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                //SizedBox(height: 20.0),
                // first name text box
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "First Name"),
                  validator: (val) => val.isEmpty ? "Enter your first name" : null,
                  onChanged: (val) {
                    setState(() => firstName = val);
                  }
                ),
                //SizedBox(height: 20.0),
                // last name text box
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Last Name"),
                  validator: (val) => val.isEmpty ? "Enter your last name" : null,
                  onChanged: (val) {
                    setState(() => lastName = val);
                  }
                ),
                //SizedBox(height: 20.0),
                // email text box
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Email"),
                  validator: (val) => val.isEmpty ? "Enter an email" : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  }
                ),
                //SizedBox(height: 20.0),
                // username text box
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Username"),
                  validator: (val) => val.isEmpty ? "Enter a username" : null,
                  onChanged: (val) {
                    setState(() => username = val);
                  }
                ),
                //SizedBox(height: 20.0),
                // password text box
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Password"),
                  validator: (val) => val.length < 6 ? "Enter a password 6+ symbols long" : ((val != confirmPassword) ? "Passwords don't match" : null),
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  }
                ),
                //SizedBox(height: 20.0),
                // confirm password text box
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: "Confirm Password"),
                  validator: (val) => ((val != confirmPassword) ? "Passwords don't match" : null),
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => confirmPassword = val);
                  }
                ),
                //SizedBox(height: 20.0),
                // register button
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text("Register", style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => loading = true);
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password, firstName, lastName, username);
                      if (result == null) {
                        setState(() { 
                          error = 'error has occured';
                          loading = false;
                          });
                        print(error);
                      } else {

                      }
                    } 
                  },
                ),
                SizedBox(height: 12.0),
                Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0)),
              ],
            ),
          )
          ),
      ),
    );
  }
}