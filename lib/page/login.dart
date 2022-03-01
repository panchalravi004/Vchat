// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unused_field, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vchat/utils/routes.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final emailcontrol = TextEditingController();
  final pwdcontrol = TextEditingController();

  String email = "";
  String pwd = "";


  late SharedPreferences pref;
  Future<void> prefInit(String e,String p) async {
    pref = await SharedPreferences.getInstance();
     pref.setString('email', e);
     pref.setString('pwd', p);
  }
  Future<void> loginUser() async {
    if (_formkey.currentState!.validate()) {
      try {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        final currentuser = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: pwd));
        prefInit(email,pwd);
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(MyRoutes.homeroutes);
      } catch (e) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Something Wrong"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[Text(e.toString())],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("OK"))
              ],
            );
          },
        );
        print(e);
      }
    }
  }

  clearText() {
    emailcontrol.clear();
    pwdcontrol.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Material(
        color: Color.fromRGBO(11, 27, 51, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 150,
              color: Colors.transparent,
              child: Center(
                child: Container(
                  width: 130,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 1),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(0, 64, 175, 1),
                        Color.fromRGBO(0, 204, 191, 1)
                      ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                height: 650,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35))),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextFormField(
                          controller: emailcontrol,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Enter Your Email",
                            labelText: "Email Address",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 56),
                        child: TextFormField(
                          controller: pwdcontrol,
                          obscureText: true,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Enter Your Password",
                            labelText: "Password",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                email = emailcontrol.text;
                                pwd = pwdcontrol.text;
                                loginUser();
                                clearText();
                              });
                            }
                          },
                          child: Container(
                            width: 120,
                            height: 35,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent[400],
                                borderRadius: BorderRadius.circular(35)),
                            child: Center(
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, MyRoutes.signuproutes);
                              },
                              child: Container(
                                width: 100,
                                height: 35,
                                decoration: BoxDecoration(
                                    color: Colors.orangeAccent[700],
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(35),
                                        bottomLeft: Radius.circular(35))),
                                child: Center(
                                  child: Text(
                                    "SIGNUP",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
