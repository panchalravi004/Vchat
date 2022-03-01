// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, invalid_return_type_for_catch_error, avoid_print, unused_import, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formkey = GlobalKey<FormState>();

  final unamecontrol = TextEditingController();
  final emailcontrol = TextEditingController();
  final pwdcontrol = TextEditingController();

  var uname = "";
  var email = "";
  var pwd = "";

  clearText() {
    unamecontrol.clear();
    emailcontrol.clear();
    pwdcontrol.clear();
  }

  /*SHOW MESSAGE */
  String msgs = "Sign Up Successfully";
  String err = "Faild to sign up";
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

  /*ADD USER */
  Future<void> addUser() async {
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
              .createUserWithEmailAndPassword(email: email, password: pwd))
          .user;
      FirebaseFirestore.instance.collection("users").doc(currentuser!.uid).set({
        'uid': currentuser.uid,
        'uname': uname,
        'email': email,
        'pwd': pwd,
        'status': "",
        'img': ""
      }).then((value) {
        Navigator.of(context).pop();
        msg(msgs);
      }).catchError((error) => msg(err + " $error"));
    } catch (e) {
      print(e);
    }
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
                      // color: Colors.red,
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
                            "SIGNUP",
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
                          controller: unamecontrol,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Enter Your Username",
                            labelText: "Username",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter User Name';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 40),
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
                        padding: const EdgeInsets.symmetric(horizontal: 40),
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
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: InkWell(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                uname = unamecontrol.text;
                                email = emailcontrol.text;
                                pwd = pwdcontrol.text;
                                addUser();
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
                                "SIGNUP",
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
                                Navigator.pop(context);
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
                                    "LOGIN",
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
