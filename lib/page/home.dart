// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vchat/page/homeAssets/appbar.dart';
import 'package:vchat/page/homeAssets/appbody.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var user = FirebaseAuth.instance.currentUser;
  late SharedPreferences pref;

  Future<void> setLogin() async {
    pref = await SharedPreferences.getInstance();
    var email = pref.getString('email');
    var pwd = pref.getString('pwd');

    if (email == null && pwd == null) {
      print("There is no user here to login !");
    } else {
      final currentuser = (await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.toString(), password: pwd.toString()));
    }
  }

  @override
  void initState() {
    super.initState();
    setLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBar(),
      body: MyAppBody(),
    );
  }
}
