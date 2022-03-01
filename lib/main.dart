// ignore_for_file: use_key_in_widget_constructors, camel_case_types, prefer_const_constructors, unused_field, avoid_print, must_be_immutable, prefer_typing_uninitialized_variables, non_constant_identifier_names, unnecessary_null_comparison, unused_local_variable, unrelated_type_equality_checks, dead_code

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vchat/page/addFriend.dart';
import 'package:vchat/page/home.dart';
import 'package:vchat/page/login.dart';
import 'package:vchat/page/signup.dart';
import 'package:vchat/page/userAssets/profile.dart';
import 'package:vchat/utils/routes.dart';
// import 'package:flutter/services.dart';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  late SharedPreferences pref;

  bool alreadyLogin = false;
  Future<void> setLogin() async {
    pref = await SharedPreferences.getInstance();
    var email = pref.getString('email');
    var pwd = pref.getString('pwd');

    if (email == null && pwd == null) {
      alreadyLogin = false;
      // print("This is current email :- " + email.toString());
      // print("This is current pwd :- " + pwd.toString());
    } else {
      alreadyLogin = true;
      // print("This is current email :- " + email.toString());
      // print("This is current pwd :- " + pwd.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    setLogin();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Something Went Worng");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute:
                  alreadyLogin ? MyRoutes.homeroutes : MyRoutes.loginroutes,
              routes: {
                MyRoutes.loginroutes: (context) => Login(),
                MyRoutes.signuproutes: (context) => Signup(),
                MyRoutes.homeroutes: (context) => Home(),
                MyRoutes.addFriendroutes: (context) => AddFriend(),
                MyRoutes.profileroutes: (context) => Profile(),
              });
        }
        return Material(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
