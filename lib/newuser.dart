import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

var cpwd;
var cmail;
var copwd;

class NewUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EasyLoading.dismiss();
    return Scaffold(
      appBar: AppBar(title: Text("Create new User")),
      body: Center(
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  height: 20,
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
                            cmail = mailid;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 20,
                ),
                Row(
                  children: [
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
                            cpwd = pass;
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 30 / 100,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 3.0, 9.0, 3.0),
                        child: Text("Confirm Password"),
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
                            hintText: "Confirm Password",
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (pass) {
                            copwd = pass;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 40,
                ),
                FlatButton.icon(
                  icon: Icon(Icons.verified_user),
                  onPressed: () async {
                    EasyLoading.show(status: "Creating ...");
                    if (copwd != null && cpwd != null && cmail != null) {
                      if (copwd == cpwd) {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                                  email: cmail, password: cpwd);
                          if (userCredential.user != null) {
                            FirebaseFirestore.instance
                                .collection('$cmail+profile')
                                .add({
                              'name': 'Unknown',
                              'phone': 'Unknown',
                              'age': 'Unknown',
                              'img': null,
                            }).then((value) {
                              EasyLoading.dismiss();
                              EasyLoading.showToast('Created User');
                            }).catchError((error) {
                              EasyLoading.dismiss();
                              EasyLoading.showToast(
                                  'Failed to add user: $error');
                            });
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            EasyLoading.dismiss();
                            EasyLoading.showToast(
                                'The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            EasyLoading.dismiss();
                            EasyLoading.showToast(
                                'The account already exists for that email.');
                          }
                        } catch (e) {
                          EasyLoading.dismiss();
                          EasyLoading.showToast(e);
                        }
                      } else {
                        EasyLoading.dismiss();
                        EasyLoading.showToast("password not match");
                      }
                    } else {
                      EasyLoading.dismiss();
                      EasyLoading.showToast('Empty Field !');
                    }
                  },
                  label: Text('Create'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
