// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, invalid_return_type_for_catch_error, prefer_typing_uninitialized_variables, unused_local_variable, unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  var user = FirebaseAuth.instance.currentUser;
  Stream<QuerySnapshot<Object?>> userStream() {
    final Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection("users")
        .where('uid', isNotEqualTo: user!.uid)
        .snapshots();
    return stream;
  }

  @override
  void initState() {
    super.initState();
    setEmail();
  }

  var currentuseremail;
  /*set user email */
  Future<void> setEmail() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((data) {
      setState(() {
        currentuseremail = data['email'].toString();
      });
    });
  }

/*Setting user status // if there is no status then it return defauld status message */
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
          CupertinoIcons.person_alt,
          color: Colors.white,
        ),
      );
    }
    return CircleAvatar(
      backgroundImage: NetworkImage(url),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
    );
  }

/*Add as Friends in our chat collections */
/*and also add our profile in our friend chat collection list */
  Future<void> addFriend(String friendEmail, String friendUid) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      var a = DateTime.now().toString();
      //add in friends list
      FirebaseFirestore.instance
          .collection("users")
          .doc(friendUid)
          .collection("friend")
          .doc(user!.uid)
          .set({
        'uid': user!.uid,
        'email': currentuseremail,
        'time': a,
      }).then((value) {
        //add in our chat list
        print("add in friend list");
        FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .collection("friend")
            .doc(friendUid)
            .set({
          'uid': friendUid,
          'email': friendEmail,
          'time': a,
        }).then((value) {
          print("added in our list");
          Navigator.of(context).pop();
        }).catchError((error) => print(error));
      }).catchError((error) => print(error));
    } catch (e) {
      print(e);
    }
  }

/*check they are already friends or not */
  Future<bool> checkFriend(String friendUid) async {
    bool docExist = false;
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("friend")
        .doc(friendUid)
        .get();
    if (doc.exists) {
      docExist = true;
    }
    return docExist;
  }

  Future<void> msg(String m) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Thank You"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(m)],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color.fromRGBO(11, 27, 51, 1),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Chat with Friend"),
              Container(
                height: 28,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white, width: 1),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 41, 88, 209),
                      Color.fromRGBO(0, 204, 191, 1)
                    ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "VCHAT",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                ),
              ),
            ],
          )),
      body: Material(
        color: Color.fromRGBO(255, 255, 255, 1),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/chat_bg.png"), fit: BoxFit.fitWidth),
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: StreamBuilder(
                    stream: userStream(),
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
                      final List data = [];
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map a = document.data() as Map<String, dynamic>;
                        data.add(a);
                      }).toList();
                      // print(data);
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (var i = 0; i < data.length; i++) ...[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
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
                                    leading: Container(
                                        width: 55,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  Color.fromARGB(
                                                      255, 61, 104, 212),
                                                  Color.fromRGBO(0, 204, 191, 1)
                                                ],
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight),
                                            color: Colors.amber,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: setProfileImg(
                                            data[i]['img'].toString())),
                                    title: Text(data[i]['uname']),
                                    subtitle: Text(setStatus(
                                        data[i]['status'].toString())),
                                    trailing: FutureBuilder(
                                        future: checkFriend(
                                            data[i]['uid'].toString()),
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (snapshot.data == true) {
                                            return Text("Already Friends !");
                                          } else {
                                            return InkWell(
                                              onTap: () {
                                                addFriend(
                                                    data[i]['email'].toString(),
                                                    data[i]['uid'].toString());
                                              },
                                              child: Icon(CupertinoIcons
                                                  .arrow_up_right_diamond_fill),
                                            );
                                          }
                                        }),
                                  ),
                                ),
                              )
                            ]
                          ]);
                    }),
              )),
        ),
      ),
    );
  }
}
