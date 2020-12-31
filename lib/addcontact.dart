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

void Add(usr) {
  CollectionReference users =
      FirebaseFirestore.instance.collection('${auth.currentUser.email}');
  users.add({
    'contact': usr,
  }).then((value) {
    EasyLoading.dismiss();
    EasyLoading.showToast('User Added');
  }).catchError((error) {
    EasyLoading.dismiss();
    EasyLoading.showToast('Failed to add user: $error');
  });
  CollectionReference user1 = FirebaseFirestore.instance.collection('$usr');
  user1
      .add({
        'contact': auth.currentUser.email,
      })
      .then((value) => print("User Added"))
      .catchError((error) => print("Failed to add user: $error"));
}

void Addd(usr) async {
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
              querySnapshot.docs.forEach((doc) {
                usrinfo.add(doc['name']);
                usrinfo.add(doc['phone']);
                usrinfo.add(doc['age']);
                usrinfo.add(doc['img']);
              })
            });
    FirebaseFirestore.instance.collection('${auth.currentUser.email}').add({
      'contact': usr,
      'name': usrinfo[0],
      'phone': usrinfo[1],
      'age': usrinfo[2],
      'img': usrinfo[3],
    }).then((value) {
      EasyLoading.dismiss();
      EasyLoading.showToast('User Added');
    }).catchError((error) {
      EasyLoading.dismiss();
      EasyLoading.showToast('Failed to add user: $error');
    });
  } else {}

  if (checkinother == false) {
    List usrinfo1 = [];
    FirebaseFirestore.instance
        .collection('${auth.currentUser.email}+profile')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                usrinfo1.add(doc['name']);
                usrinfo1.add(doc['phone']);
                usrinfo1.add(doc['age']);
                usrinfo1.add(doc['img']);
              })
            });
    FirebaseFirestore.instance.collection('$usr').add({
      'contact': usr,
      'name': usrinfo1[0],
      'phone': usrinfo1[1],
      'age': usrinfo1[2],
      'img': usrinfo1[3],
    }).then((value) {
      EasyLoading.dismiss();
      EasyLoading.showToast('User Added');
    }).catchError((error) {
      EasyLoading.dismiss();
      EasyLoading.showToast('Failed to add user: $error');
    });
  } else {}
}
