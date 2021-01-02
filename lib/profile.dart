import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

FirebaseAuth auth = FirebaseAuth.instance;
var name;
var age;
var ph;
var img;
var name1;
var age1;
var ph1;
var img1;

Future<void> uploadFile(String filePath) async {
  EasyLoading.show(status: "uploading image");
  File file = File(filePath);
  try {
    await firebase_storage.FirebaseStorage.instance
        .ref('${auth.currentUser.email}+profile')
        .putFile(file);
  } on firebase_storage.FirebaseException catch (e) {
    EasyLoading.dismiss();
    EasyLoading.showToast(e.toString());
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File _image;
  String _imagepath;
  final picker = ImagePicker();
  void Refresh() async {
    await FirebaseFirestore.instance
        .collection('${auth.currentUser.email}+profile')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  img = doc['img'];
                  name = doc['name'];
                  age = doc['age'];
                  ph = doc['phone'];
                });
              })
            });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imagepath = pickedFile.path;
      } else {
        EasyLoading.showToast("NO Image selected");
      }
    });
  }

  Widget _profileimg() {
    if (_image != null) {
      return Image.file(_image);
    } else if (img != null) {
      return Image(image: NetworkImage(img));
    } else {
      return Image(
          height: MediaQuery.of(context).size.height * 50 / 100,
          image: NetworkImage(
              'https://firebasestorage.googleapis.com/v0/b/chatapp-930d1.appspot.com/o/user-image-.png?alt=media&token=99ae11b6-ca74-4205-94e3-334d1287ccc7'));
    }
  }

  var phController = TextEditingController();
  var ageController = TextEditingController();
  var nameController = TextEditingController();
  @override
  void initState() {
    EasyLoading.dismiss();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Refresh();
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(children: [
        GestureDetector(
          onTap: () {
            getImage();
          },
          child: Container(
              height: MediaQuery.of(context).size.height * 40 / 100,
              width: double.infinity,
              decoration: BoxDecoration(),
              alignment: Alignment(0, 0),
              child: _profileimg()),
        ),
        Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 30 / 100,
                child: Text(
                  'Name',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width * 70 / 100,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 3.0, 9.0, 3.0),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: name == null ? "Name" : name,
                  ),
                  keyboardType: TextInputType.name,
                  onChanged: (name12) {
                    name1 = name12;
                  },
                ),
              ),
            ),
          ],
        ),
        Container(height: 20),
        Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 30 / 100,
                child: Text(
                  'Age',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width * 70 / 100,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 3.0, 9.0, 3.0),
                child: TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: age == null ? "Age " : age,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (message) {
                    age1 = message;
                  },
                ),
              ),
            ),
          ],
        ),
        Container(height: 20),
        Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 30 / 100,
                child: Text(
                  'Phone no.',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20),
              ),
              width: MediaQuery.of(context).size.width * 70 / 100,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 3.0, 9.0, 3.0),
                child: TextField(
                  controller: phController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: ph == null ? "Phone no" : ph,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (message) {
                    ph1 = message;
                  },
                ),
              ),
            ),
          ],
        ),
        Container(height: 20),
        Container(
          child: FlatButton.icon(
              onPressed: () {
                name1 == null ? name1 = name : print(name);
                age1 == null ? age1 = age : print(age);
                ph1 == null ? ph1 = ph : print(ph1);
                img1 == null ? img1 = img : print(img1);

                Update(name1, age1, ph1, img1, _imagepath);
                phController.clear();
                nameController.clear();
                ageController.clear();
              },
              icon: Icon(Icons.update),
              label: Text("Update")),
        ),
      ]),
    );
  }
}

DeleteOldUPdate(timee) async {
  List con = [];
  await FirebaseFirestore.instance
      .collection('${auth.currentUser.email}')
      .get()
      .then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              print("con" + doc['contact']);
              var a = doc['contact'];
              con.add(a);
              print("aaa $con");
            })
          });
  for (var i = 0; i < con.length; i++) {
    print(con[i]);
    FirebaseFirestore.instance
        .collection('${con[i]}+update')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                print(doc['contact']);
                if (con[i] == doc['contact'] && doc['time'] != timee) {
                  print(con[i]);
                  FirebaseFirestore.instance
                      .collection('${con[i]}+update')
                      .doc(doc.id)
                      .delete();
                } else {}
              })
            });
  }
}

void ProfileUpdate(namee, agee, phh, imgg, timee) {
  FirebaseFirestore.instance
      .collection('${auth.currentUser.email}')
      .get()
      .then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) {
              FirebaseFirestore.instance
                  .collection('${doc['contact']}+update')
                  .add({
                'contact': auth.currentUser.email,
                'img': imgg,
                'name': namee,
                'age': agee,
                'phone': phh,
                'time': timee,
              });
            })
          });
  FirebaseFirestore.instance
      .collection('${auth.currentUser.email}+profile')
      .get()
      .then((QuerySnapshot querySnapshot) => {
            print(querySnapshot.size),
            if (querySnapshot.size == 0)
              {
                FirebaseFirestore.instance
                    .collection('${auth.currentUser.email}+profile')
                    .add(
                        {'name': namee, 'age': agee, 'phone': phh, 'img': imgg})
              }
            else
              {
                querySnapshot.docs.forEach((doc) {
                  FirebaseFirestore.instance
                      .collection('${auth.currentUser.email}+profile')
                      .doc(doc.id)
                      .update({
                    'name': namee,
                    'age': agee,
                    'phone': phh,
                    'img': imgg
                  });
                })
              }
          });
}

Update(n, a, p, i, img_path) async {
  var time = DateTime.now().millisecondsSinceEpoch;
  if (img_path != null) {
    uploadFile(img_path);
    String i = await firebase_storage.FirebaseStorage.instance
        .ref('${auth.currentUser.email}+profile')
        .getDownloadURL();
    EasyLoading.dismiss();
    await DeleteOldUPdate(time);
    ProfileUpdate(n, a, p, i, time);
    EasyLoading.dismiss();
  } else {
    EasyLoading.dismiss();
    await DeleteOldUPdate(time);
    ProfileUpdate(n, a, p, i, time);
    EasyLoading.dismiss();
  }
}

Future<void> downloadURLExample() async {
  String downloadURL = await firebase_storage.FirebaseStorage.instance
      .ref('${auth.currentUser.email}+profile')
      .getDownloadURL();
  EasyLoading.dismiss();
  return downloadURL;
}
