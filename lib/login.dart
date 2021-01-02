import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'main.dart';

var mail;
var pwd;
var cmail;
var cpwd;
FirebaseAuth auth = FirebaseAuth.instance;

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EasyLoading.dismiss();
    return Scaffold(
        appBar: AppBar(
          title: Text("Login Page"),
        ),
        body: Center(
          child: ListView(
            children: [
              Container(
                height: 25,
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 30 / 100,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 3.0, 9.0, 3.0),
                      child: Text("Email id"),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 70 / 100,
                    decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 3.0, 9.0, 3.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email id",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (mailid) {
                          mail = mailid;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 20,
              ),
              Row(children: [
                Container(
                  width: MediaQuery.of(context).size.width * 30 / 100,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 3.0, 9.0, 3.0),
                    child: Text("Password"),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 70 / 100,
                  decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 3.0, 9.0, 3.0),
                    child: TextField(
                      obscureText: true,
                      obscuringCharacter: "#",
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      onChanged: (pass) {
                        pwd = pass;
                      },
                    ),
                  ),
                ),
              ]),
              Container(
                height: 20,
              ),
              FlatButton.icon(
                label: Text('Submit'),
                icon: Icon(Icons.done),
                onPressed: () async {
                  try {
                    if (pwd != null && mail != null) {
                      EasyLoading.show(status: 'loading...');
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                              email: mail, password: pwd);
                      navigatorKey.currentState.pushNamed('/main');
                    } else {
                      EasyLoading.showToast("Enter password or mail");
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      EasyLoading.dismiss();
                      EasyLoading.showToast('No user found for that email.');
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      EasyLoading.dismiss();
                      EasyLoading.showError(
                          'Wrong password provided for that user.');
                      print('Wrong password provided for that user.');
                    }
                  }
                },
              ),
              Container(
                child: FlatButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, "/newuser");
                    },
                    icon: Icon(Icons.create),
                    label: Text("Create new User")),
              ),
            ],
          ),
        ));
  }
}
