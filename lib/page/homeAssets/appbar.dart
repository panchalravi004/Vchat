// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, avoid_returning_null_for_void

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vchat/utils/routes.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(125);
}

class _MyAppBarState extends State<MyAppBar> {
  var user = FirebaseAuth.instance.currentUser;
  bool click = false;

  late SharedPreferences pref;
  Future<void> prefInit() async {
    pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  Future<void> logout() async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      await Future.delayed(Duration(seconds: 1));
      var user = FirebaseAuth.instance;
      user.signOut();
      prefInit();
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(MyRoutes.loginroutes);
    } catch (e) {
      print(e);
    }
  }

  final RelativeRect position = RelativeRect.fromLTRB(1, 0, 0, 0);
  Future<dynamic> showBox() {
    return showMenu(context: context, position: position, items: [
      PopupMenuItem<int>(
          value: 0,
          child: ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(MyRoutes.profileroutes);
            },
            minLeadingWidth: 0,
            leading: Icon(CupertinoIcons.profile_circled),
            trailing: Text("Profile"),
          )),
      PopupMenuItem<int>(
          value: 1,
          child: ListTile(
            minLeadingWidth: 0,
            leading: Icon(Icons.search),
            trailing: Text("Search"),
          )),
      PopupMenuItem<int>(
          value: 2,
          child: ListTile(
            minLeadingWidth: 0,
            leading: Icon(Icons.settings),
            trailing: Text("Settings"),
          )),
      PopupMenuItem<int>(
          value: 3,
          child: ListTile(
            onTap: () {
              Navigator.of(context).pushNamed(MyRoutes.addFriendroutes);
            },
            minLeadingWidth: 0,
            leading: Icon(Icons.add),
            trailing: Text("Friends"),
          )),
      PopupMenuItem<int>(
          value: 4,
          child: ListTile(
            onTap: () => logout(),
            minLeadingWidth: 0,
            leading: Icon(Icons.logout_rounded),
            trailing: Text("Logout"),
          ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      toolbarHeight: 130,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(11, 27, 51, 1),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      // width: 130,
                      height: 28,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 1),
                          gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 41, 88, 209),
                                Color.fromRGBO(0, 204, 191, 1)
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight)),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () {
                        showBox();
                      },
                      child: Icon(
                        Icons.menu_open_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 90,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 36, 58, 92),
                        borderRadius: BorderRadius.circular(35)),
                    child: Center(
                      child: Text(
                        "CHATS",
                        style: TextStyle(
                            color: Color.fromARGB(255, 233, 233, 233),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    width: 90,
                    height: 25,
                    decoration: BoxDecoration(
                        color: click
                            ? Colors.white
                            : Color.fromARGB(255, 36, 58, 92),
                        borderRadius: BorderRadius.circular(35)),
                    child: Center(
                      child: Text(
                        "STATUS",
                        style: TextStyle(
                            color: click
                                ? Colors.black
                                : Color.fromARGB(255, 233, 233, 233),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2),
                      ),
                    ),
                  ),
                  Container(
                    width: 90,
                    height: 25,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 36, 58, 92),
                        borderRadius: BorderRadius.circular(35)),
                    child: Center(
                      child: Text(
                        "CALLS",
                        style: TextStyle(
                            color: Color.fromARGB(255, 233, 233, 233),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
