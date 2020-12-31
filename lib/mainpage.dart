import 'package:chat/fullscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'test.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_easyloading/flutter_easyloading.dart';

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

FirebaseAuth auth = FirebaseAuth.instance;

UpdateData() async {
  List data = [];
  await FirebaseFirestore.instance
      .collection('${auth.currentUser.email}+update')
      .get()
      .then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              print("con" + doc['contact']);
              data.add(doc['contact']);
              data.add(doc['name']);
              data.add(doc['phone']);
              data.add(doc['age']);
              data.add(doc['img']);
              FirebaseFirestore.instance
                  .collection('${auth.currentUser.email}+update')
                  .doc(doc.id)
                  .delete();
            })
          });
  print(data);
  for (var i = 0; i < data.length; i += 5) {
    FirebaseFirestore.instance
        .collection('${auth.currentUser.email}')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                print(doc['contact']);
                if (data[i] == doc['contact']) {
                  FirebaseFirestore.instance
                      .collection('${auth.currentUser.email}')
                      .doc(doc.id)
                      .update({
                    'name': data[i + 1],
                    'phone': data[i + 2],
                    'age': data[i + 3],
                    "img": data[i + 4],
                  });
                } else {}
              })
            });
  }
}

class _MainpageState extends State<Mainpage> {
  var profileimg;
  var name;
  var age;
  var ph;
  void Refresh() async {
    await FirebaseFirestore.instance
        .collection('${auth.currentUser.email}+profile')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  profileimg = doc['img'];
                });
              })
            });
    await FirebaseFirestore.instance
        .collection('${auth.currentUser.email}+profile')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  name = doc['name'];
                  age = doc['age'];
                  ph = doc['phone'];
                });
              })
            });
  }

  @override
  void initState() {
    Refresh();
    UpdateData();
    super.initState();
  }

  Widget build(BuildContext context) {
    EasyLoading.dismiss();
    CollectionReference users =
        FirebaseFirestore.instance.collection('${auth.currentUser.email}');
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat's"),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                Refresh();
                UpdateData();
              })
        ],
      ),
      drawer: Drawer(
        child: ListView(children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreen(
                      imgurl: profileimg == null
                          ? 'https://firebasestorage.googleapis.com/v0/b/chatapp-930d1.appspot.com/o/user-image-.png?alt=media&token=99ae11b6-ca74-4205-94e3-334d1287ccc7'
                          : profileimg,
                    ),
                  ));
            },
            child: Container(
                color: Colors.blue,
                child: profileimg == null
                    ? Image(
                        image: NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/chatapp-930d1.appspot.com/o/user-image-.png?alt=media&token=99ae11b6-ca74-4205-94e3-334d1287ccc7'))
                    : Image(image: NetworkImage(profileimg))),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    auth.currentUser.email,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  name == null ? Text('Unknown') : Text(name),
                  ph == null ? Text('Unknown') : Text(ph)
                ],
              ),
            ),
          ),
          FlatButton.icon(
              onPressed: () {
                UpdateData();
              },
              icon: Icon(Icons.update),
              label: Text("Update users information")),
          FlatButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },
              icon: Icon(Icons.person_add),
              label: Text("Add Contact")),
          FlatButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              icon: Icon(Icons.person_pin),
              label: Text("Edit Profile")),
          FlatButton.icon(
              onPressed: () async {
                EasyLoading.show(status: "Sign Out");
                await FirebaseAuth.instance.signOut();

                if (auth.currentUser == null) {
                  EasyLoading.dismiss();
                  navigatorKey.currentState.pushNamed('/main');
                } else {
                  EasyLoading.dismiss();
                }
              },
              icon: Icon(Icons.arrow_back_ios),
              label: Text("Sign out")),
        ]),
      ),
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
        stream: users.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.done ||
              snapshot.connectionState == ConnectionState.active) {
            return new ListView(
              children: snapshot.data.docs.map(
                (DocumentSnapshot document) {
                  return Column(
                    children: [
                      new ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreen(
                                    imgurl: document.data()['img'] == null
                                        ? 'https://firebasestorage.googleapis.com/v0/b/chatapp-930d1.appspot.com/o/user-image-.png?alt=media&token=99ae11b6-ca74-4205-94e3-334d1287ccc7'
                                        : document.data()['img'],
                                  ),
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'https://firebasestorage.googleapis.com/v0/b/chatapp-930d1.appspot.com/o/user-image-.png?alt=media&token=99ae11b6-ca74-4205-94e3-334d1287ccc7')),
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: document.data()['img'] == null
                                ? Image(
                                    image: NetworkImage(
                                        'https://firebasestorage.googleapis.com/v0/b/chatapp-930d1.appspot.com/o/user-image-.png?alt=media&token=99ae11b6-ca74-4205-94e3-334d1287ccc7'))
                                : Image(
                                    image: NetworkImage(document.data()['img']),
                                  ),
                          ),
                        ),
                        title: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MsgScreen(
                                    text: document.data()['name'],
                                  ),
                                ));
                          },
                          child: Container(
                              child: Padding(
                            padding: EdgeInsets.all(16),
                            child: new Text(
                              document.data()['name'],
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16.0,
                              ),
                            ),
                          )),
                        ),
                        subtitle: Text(document.data()['contact']),
                      ),
                      Container(
                        child: Text("______________________________"),
                      ),
                    ],
                  );
                },
              ).toList(),
            );
          } else {
            print('${snapshot.connectionState} ${ConnectionState.done}');
            return Text('Loading');
          }
        },
      )),
    );
  }
}
