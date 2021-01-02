import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String msg;
String state = "add";

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  @override
  void initState() {
    EasyLoading.dismiss();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add User"),
      ),
      body: Center(
        child: ListView(
          children: [
            Container(child: Text("Enter mail id")),
            TextField(
              decoration: InputDecoration(
                hintText: "Email id",
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (txt) {
                msg = txt;
              },
            ),
            FlatButton.icon(
                onPressed: () {
                  EasyLoading.show(status: 'Please wait ...');
                  Add(msg);
                },
                icon: Icon(Icons.done),
                label: Text("Add User")),
          ],
        ),
      ),
    );
  }
}

void Add(usr) async {
  bool checkincurrent = false;
  bool checkinother = false;
  await FirebaseFirestore.instance
      .collection('${auth.currentUser.email}')
      .get()
      .then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              if (doc['contact'] == usr) {
                checkincurrent = true;
              }
            })
          });
  await FirebaseFirestore.instance
      .collection('$usr')
      .get()
      .then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              if (doc['contact'] == auth.currentUser.email) {
                checkinother = true;
              }
            })
          });
  if (checkincurrent == false) {
    List usrinfo = [];
    FirebaseFirestore.instance
        .collection('$usr+profile')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              if (querySnapshot.size != 0)
                {
                  querySnapshot.docs.forEach((doc) {
                    FirebaseFirestore.instance
                        .collection('${auth.currentUser.email}')
                        .add({
                      'contact': usr,
                      'name': doc['name'],
                      'phone': doc['phone'],
                      'age': doc['age'],
                      'img': doc['img'],
                    }).then((value) {
                      EasyLoading.dismiss();
                      EasyLoading.showToast('User Added');
                    }).catchError((error) {
                      EasyLoading.dismiss();
                      EasyLoading.showToast('Failed to add user: $error');
                    });
                  })
                }
              else
                {
                  EasyLoading.dismiss(),
                  EasyLoading.showToast('User does not exist')
                }
            });
  } else {
    EasyLoading.dismiss();
    EasyLoading.showToast('User Already Added');
  }

  if (checkinother == false) {
    List usrinfo1 = [];
    FirebaseFirestore.instance
        .collection('${auth.currentUser.email}+profile')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                FirebaseFirestore.instance.collection('$usr').add({
                  'contact': auth.currentUser.email,
                  'name': doc['name'],
                  'phone': doc['phone'],
                  'age': doc['age'],
                  'img': doc['img'],
                }).then((value) {
                  EasyLoading.dismiss();
                  EasyLoading.showToast('User Added');
                }).catchError((error) {
                  EasyLoading.dismiss();
                  EasyLoading.showToast('Failed to add user: $error');
                });
              })
            });
  } else {}
}
