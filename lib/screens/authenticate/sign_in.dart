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
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(

              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text("  TaskV"),
              //actions: <Widget>[
                //FlatButton.icon(
                  //onPressed: () {
                      //widget.toggleView();
                    //},
                    //icon: Icon(Icons.person),
                    //label: Text("Sign Up"))
              //],
            ),
            body: SingleChildScrollView(
              //height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Sign In", style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 15.0),
                    Text("- Login to TaskV -", style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[800]
                    ),),
                    SizedBox(height: 28.0),
                    TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email",
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400])
                          ),
                        ),
                        validator: (val) =>
                            val.isEmpty ? "Enter an email" : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        }),
                    SizedBox(height: 10.0),
                    TextFormField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400])
                          ),
                        ),
                        validator: (val) => val.length < 6
                            ? "Enter a password 6+ symbols long"
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => password = val);
                        }),
                    SizedBox(height: 14.0),
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 40,
                      color: Colors.blue[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Text("Sign in",
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'Problem Signing In';
                              loading = false;
                            });
                            print(error);
                          }
                        }
                      },
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account? "),
                        FlatButton(
                          color: Colors.transparent,
                          textColor: Colors.black,
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 1.0, 0.0),
                          onPressed: (){
                            widget.toggleView();
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 18)
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/login_pic.png"),
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0)),
                  ],
                ),
              ),
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

/*body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/TaskVMainLogo.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),

        body: Image.asset('assets/TaskVMainLogo.png')
        */
//Image.asset('TaskVMainLogo.png'),
