// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, prefer_typing_uninitialized_variables, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vchat/page/userchat.dart';
import 'package:vchat/utils/routes.dart';

class MyAppBody extends StatefulWidget {
  const MyAppBody({Key? key}) : super(key: key);

  @override
  _MyAppBodyState createState() => _MyAppBodyState();
}

class _MyAppBodyState extends State<MyAppBody> {
  var user = FirebaseAuth.instance.currentUser;

  Stream<QuerySnapshot<Object?>> currentuserStream() {
    final Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("friend")
        .orderBy('time', descending: true)
        .snapshots();
    return stream;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream(String uid) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> stream =
        FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
    return stream;
  }

  String setStatus(String s) {
    if (s == "") {
      return "Available";
    }
    return s;
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

//show last message time in trailing point
  showTime(String time) {
    String todayDate = DateTime.now().toString();
    //for todays date
    String todaydt = ""; //get only date using for loop
    for (var i = 0; i < 10; i++) {
      todaydt = todaydt + todayDate[i];
    }
    // print("today " + todaydt);

    //get data and time only from time parameter
    String dt = ""; //get only date using for loop
    for (var i = 0; i < 10; i++) {
      dt = dt + time[i];
    }
    // print("time para date " + dt);
    //get time from time parameter
    String t = ""; //this is time
    for (var i = 11; i < 16; i++) {
      t = t + time[i];
    }
    // print("Thi si is time " + t);
    if (dt == todaydt) {
      return Text(
        "Last seen : " + t,
        style: TextStyle(color: Colors.black26, fontWeight: FontWeight.w600),
      );
    } else {
      return Text(
        "Last seen : " + dt,
        style: TextStyle(color: Colors.black26, fontWeight: FontWeight.w600),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/chat_bg.png"), fit: BoxFit.fitWidth),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Column(
            children: [
              StreamBuilder(
                  stream: currentuserStream(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError) {
                      print('something wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(
                          height: 250,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }
                    final List maindata = [];
                    snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map a = document.data() as Map<String, dynamic>;
                      maindata.add(a);
                    }).toList();
                    // print(maindata);
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (var i = 0; i < maindata.length; i++) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          offset: Offset(0, 0),
                                          spreadRadius: 0,
                                          blurRadius: 10)
                                    ]),
                                child: ListTile(
                                  onTap: () async {
                                    // getData(maindata[i]['uid']);
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (context) {
                                    //     return Center(
                                    //       child: CircularProgressIndicator(),
                                    //     );
                                    //   },
                                    // );
                                    // await Future.delayed(Duration(seconds: 1));
                                    // Navigator.of(context).pop();
                                    setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => UserChat(
                                                    frienduid: maindata[i]
                                                            ['uid']
                                                        .toString(),
                                                  )));
                                    });
                                  },
                                  leading: Container(
                                    width: 55,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(0, 0),
                                              spreadRadius: 0,
                                              blurRadius: 10)
                                        ],
                                        gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 61, 104, 212),
                                              Color.fromRGBO(0, 204, 191, 1)
                                            ],
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight),
                                        color: Colors.amber,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(maindata[i]['uid'])
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return CircularProgressIndicator();
                                        }
                                        return setProfileImg(
                                            snapshot.data['img'].toString());
                                      },
                                    ),
                                  ),
                                  title: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(maindata[i]['uid'])
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (!snapshot.hasData) {
                                        return LinearProgressIndicator(
                                          backgroundColor: Color.fromARGB(
                                              255, 230, 230, 230),
                                        );
                                      }
                                      return Text(
                                          (snapshot.data['uname'].toString()));
                                    },
                                  ),
                                  subtitle: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(maindata[i]['uid'])
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      if (!snapshot.hasData) {
                                        return LinearProgressIndicator(
                                          backgroundColor: Color.fromARGB(
                                              255, 230, 230, 230),
                                        );
                                      }
                                      return Text(setStatus(
                                          snapshot.data['status'].toString()));
                                    },
                                  ),
                                  trailing:
                                      showTime(maindata[i]['time'].toString()),
                                ),
                              ),
                            )
                          ],
                        ],
                      ),
                    );
                  }),
              Expanded(
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FloatingActionButton(
                          hoverColor: Colors.amber,
                          backgroundColor: Color.fromARGB(255, 74, 194, 78),
                          splashColor: Color.fromARGB(255, 255, 136, 25),
                          tooltip: 'Chats',
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(MyRoutes.addFriendroutes);
                          },
                          child: Icon(CupertinoIcons.chat_bubble_text_fill),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
