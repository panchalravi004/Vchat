// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, invalid_return_type_for_catch_error, avoid_print, unused_local_variable, dead_code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UserChat extends StatefulWidget {
  final String frienduid;
  const UserChat({Key? key, required this.frienduid}) : super(key: key);

  @override
  _UserChatState createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  var user = FirebaseAuth.instance.currentUser;

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendStream(String uid) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> stream =
        FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
    return stream;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatStream(
      String uid, String frienduid) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> stream = FirebaseFirestore
        .instance
        .collection("chatroom")
        .where('sender', whereIn: [uid, frienduid]).snapshots();
    return stream;
  }

/*set user image if there is no url then add default icon for profile*/
  setProfileImg(String url) {
    if (url == "") {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          CupertinoIcons.person_fill,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      );
    }
    return CircleAvatar(
      backgroundImage: NetworkImage(url),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
    );
  }

  var a = Color.fromARGB(255, 226, 29, 88);
  var b = Color.fromARGB(255, 116, 30, 185);

  //send message to our freind
  final _formkey = GlobalKey<FormState>();
  final msgcontrol = TextEditingController();
  String msg = "";
  Future<void> sendMsg() async {
    try {
      var time = DateTime.now().toString();

      //update friends last seen time in our friend list
      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("friend")
          .doc(widget.frienduid)
          .update({'time': time});
      //update our last seen time in friend's friend list
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.frienduid)
          .collection("friend")
          .doc(user!.uid)
          .update({'time': time});
      //send message to friend 
      FirebaseFirestore.instance.collection("chatroom").doc(time).set({
        'time': time,
        'sender': user!.uid.toString(),
        'receiver': widget.frienduid,
        'msg': msg,
      }).then((value) {
        print("sent successfully !");
      }).catchError((error) => print(error));
    } catch (e) {
      print(e);
    }
  }

  userChatDec() {
    return BoxDecoration(
        color: Color.fromARGB(255, 130, 33, 209),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 0),
              spreadRadius: 2,
              blurRadius: 5)
        ],
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ));
  }

  friendChatDec() {
    return BoxDecoration(
        color: Color.fromARGB(255, 241, 36, 98),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 0),
              spreadRadius: 2,
              blurRadius: 5)
        ],
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ));
  }

//show date for message ==> for date wise message
  String currentDate = "";
  shoeDate(String date) {
    String todayDate = DateTime.now().toString();
    // print("today " + todayDate);
    //for todays date
    String todaydt = ""; //get only date using for loop
    for (var i = 0; i < 10; i++) {
      todaydt = todaydt + todayDate[i];
    }
    //for fetch date
    String dt = ""; //get only date using for loop
    for (var i = 0; i < 10; i++) {
      dt = dt + date[i];
    }
    // print(dt);
    if (currentDate == dt) {
      return Container();
    } else {
      currentDate = dt;
      if (todaydt == currentDate) {
        return Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 219, 219, 219),
                border: Border.all(width: 2, color: Colors.white),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 0),
                      spreadRadius: 2,
                      blurRadius: 0)
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                "today",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ));
      } else {
        return Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 219, 219, 219),
                border: Border.all(width: 2, color: Colors.white),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 0),
                      spreadRadius: 2,
                      blurRadius: 2)
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Text(
                dt,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ));
      }
    }
  }
//show time on message
  showMsgTime(String time){
    String t = ""; //this is time
    for (var i = 11; i < 16; i++) {
      t = t + time[i];
    }
    return t;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(11, 27, 51, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamBuilder(
                stream: friendStream(widget.frienduid),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 36, 58, 92),
                            borderRadius: BorderRadius.circular(35)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 12),
                          child: Text(snapshot.data['uname'].toString(),style: TextStyle(fontSize: 18),),
                        )),
                  );
                }),
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 0),
                        spreadRadius: 0,
                        blurRadius: 10)
                  ],
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 61, 104, 212),
                    Color.fromRGBO(0, 204, 191, 1)
                  ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                  color: Colors.amber,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(50)),
              child: StreamBuilder(
                  stream: friendStream(widget.frienduid),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return setProfileImg(snapshot.data['img'].toString());
                  }),
            ),
          ],
        ),
      ),
      body: Material(
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/chat_bg.png"), fit: BoxFit.fitWidth),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    child: Container(
                        width: 390,
                        // height: 550,
                        color: Colors.transparent,
                        child: StreamBuilder(
                            stream: chatStream(
                                user!.uid.toString(), widget.frienduid),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasError) {
                                print('something wrong');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: SizedBox(
                                    height: 250,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                );
                              }
                              final List chatdata = [];
                              snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map a = document.data() as Map<String, dynamic>;
                                chatdata.add(a);
                              }).toList();
                              // print(chatdata);
                              currentDate="";//for new message appear it will maintain it self
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  for (var i = 0; i < chatdata.length; i++) ...[
                                    if (chatdata[i]['receiver'] ==
                                            widget.frienduid ||
                                        chatdata[i]['receiver'] ==
                                            user!.uid.toString()) ...[
                                      shoeDate(chatdata[i]['time']),
                                      Row(
                                        mainAxisAlignment: (chatdata[i]
                                                    ['sender'] ==
                                                user!.uid.toString())
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Container(
                                              width: 360,
                                              color: Colors.transparent,
                                              child: Row(
                                                mainAxisAlignment: (chatdata[i]
                                                            ['sender'] ==
                                                        user!.uid.toString())
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: (chatdata[i]
                                                            ['sender'] ==
                                                        user!.uid.toString())
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                                    
                                                    children: [
                                                      Container(
                                                        decoration: (chatdata[i]
                                                                    ['sender'] ==
                                                                user!.uid
                                                                    .toString())
                                                            ? userChatDec()
                                                            : friendChatDec(),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            chatdata[i]['msg'],
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                       Text(showMsgTime(chatdata[i]['time']),style: TextStyle(backgroundColor: Colors.white,color: Color.fromARGB(255, 158, 158, 158)))
                                                    ],
                                                  ),
                                                  
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ],
                              );
                            })),
                  ),
                ),
              ),
              Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: 340,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(45),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                                blurRadius: 10)
                          ],
                        ),
                        child: TextFormField(
                          controller: msgcontrol,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "type here to send message",
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        tooltip: "Send",
                        mini: true,
                        onPressed: () {
                          // print(DateTime.now());
                          // print("my uid" + user!.uid);
                          // print("my friend" + widget.frienduid);
                          if (msgcontrol.text.isNotEmpty) {
                            setState(() {
                              msg = msgcontrol.text;
                              sendMsg();
                              msgcontrol.clear();
                              currentDate = "";
                            });
                          }
                        },
                        backgroundColor: Color.fromARGB(255, 62, 179, 66),
                        child: Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
