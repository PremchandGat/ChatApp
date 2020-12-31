import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

FirebaseAuth auth = FirebaseAuth.instance;
// ignore: non_constant_identifier_names
void Msg(sender, receiver, msg) {
  List senderReceiver = [sender, receiver];
  senderReceiver.sort((a, b) => a.compareTo(b));
  FirebaseFirestore.instance
      .collection('${senderReceiver[0]}+${senderReceiver[1]}')
      .doc()
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      print('Document data: ${documentSnapshot.data()}');
    } else {
      print('Document does not exist on the database');
    }
  });
  CollectionReference users = FirebaseFirestore.instance
      .collection('${senderReceiver[0]}+${senderReceiver[1]}');
  users
      .add({
        'sender': sender, // John Doe
        'receiver': receiver, // Stokes and Sons
        'msg': msg,
        'time': DateTime.now().millisecondsSinceEpoch,
        'time1': DateTime.now() // 42
      })
      .then((value) => print('msg sent'))
      .catchError(
          (error) => EasyLoading.showToast("Failed to add user: $error"));
}

class MsgScreen extends StatefulWidget {
  final String text;
  MsgScreen({Key key, this.text}) : super(key: key);
  @override
  _MsgScreenState createState() => _MsgScreenState(text);
}

var msg;

class _MsgScreenState extends State<MsgScreen> {
  String receiver;
  _MsgScreenState(this.receiver);
  String sender = auth.currentUser.email;
  var msgController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    List text = [receiver, sender];
    text.sort((a, b) => a.compareTo(b));
    print("hello");
    print("$sender $receiver ${text[0]}+${text[1]} ");
    CollectionReference users =
        FirebaseFirestore.instance.collection('${text[0]}+${text[1]}');
    return Scaffold(
      appBar: AppBar(
        title: Text(receiver),
      ),
      body: ListView(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 80 / 100,
              child: StreamBuilder<QuerySnapshot>(
                stream: users.orderBy('time', descending: true).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  if (snapshot.connectionState == ConnectionState.done ||
                      snapshot.connectionState == ConnectionState.active) {
                    return new ListView(
                      controller: _scrollController,
                      reverse: true,
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        print("msg: " + document.data()['msg']);
                        if (document.data()['sender'] ==
                            auth.currentUser.email) {
                          return GestureDetector(
                            onDoubleTap: () {
                              users.doc(document.id).delete();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                new Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blue[200],
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        80 /
                                        100,
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: new Text(
                                        document.data()['msg'],
                                        style: TextStyle(
                                          fontSize:
                                              document.data()['msg'].length >= 5
                                                  ? 16.0
                                                  : 60,
                                        ),
                                      ),
                                    )),
                                Container(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onDoubleTap: () {
                              users.doc(document.id).delete();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.green[200]),
                                    width: MediaQuery.of(context).size.width *
                                        80 /
                                        100,
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: new Text(
                                        document.data()['msg'],
                                        style: TextStyle(
                                          fontSize:
                                              document.data()['msg'].length >= 5
                                                  ? 16.0
                                                  : 60,
                                        ),
                                      ),
                                    )),
                                Container(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        }
                      }).toList(),
                    );
                  } else {
                    return Text(
                      "Loading .....",
                      style: TextStyle(fontSize: 50),
                    );
                  }
                },
              )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 85 / 100,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 3.0, 9.0, 3.0),
                  child: TextField(
                    controller: msgController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter your message ",
                    ),
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    onChanged: (message) {
                      msg = message;
                    },
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    String check = msg;
                    msgController.clear();
                    check = check.replaceAll(" ", '');
                    if (check.length != 0) {
                      Msg(auth.currentUser.email, receiver, msg);
                      msg = null;
                    } else {
                      EasyLoading.showToast('nothing to send');
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
