// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var user = FirebaseAuth.instance.currentUser;

//set image at profile if null then icon show
  setProfileImg(String url) {
    if (url == "") {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        // child: Image(image: NetworkImage(url)),
        child: Icon(
          CupertinoIcons.camera_fill,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
      );
    }
    return CircleAvatar(
        backgroundImage: NetworkImage(url),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        child: Icon(
          CupertinoIcons.camera_fill,
          color: Color.fromARGB(255, 255, 255, 255),
          size: 35,
        ));
  }

  final unamecontrol = TextEditingController();
  final statuscontrol = TextEditingController();

  Future<void> msg(String msg) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thank You"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(msg)],
            ),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(), child: Text("OK"))
          ],
        );
      },
    );
  }

  //Select image from gallery
  late File _image;
  bool simg = false;
  selectImage() async {
    final img = ImagePicker();
    final imageFile =
        await img.pickImage(source: ImageSource.gallery, imageQuality: 35);
    setState(() {
      simg = true;
      _image = File(imageFile!.path);
    });
  }

  //Upload Image in Firebase Storage
  Future<String> uploadFile(File image) async {
    String URL;
    final ref = FirebaseStorage.instance
        .ref()
        .child("ProfileImg")
        .child("profile_img_" + user!.uid.toString() + ".jpg");
    await ref.putFile(image);
    URL = await ref.getDownloadURL();
    return URL;
  }

  //update users data profile
  Future<void> updateData() async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({
        'uname': unamecontrol.text,
        'status': statuscontrol.text,
      });
      Navigator.of(context).pop();
      msg('Data SuccessFully Updated !');
    } catch (e) {
      print(e);
    }
  }

  Future<void> addImgData() async {
    try {
      if (simg == true) {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
        String URL = await uploadFile(_image);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .update({'img': URL});
        Navigator.of(context).pop();
        msg('Image Updated !');
      } else {
        msg('Please Select Image First !');
      }
    } catch (e) {
      print(e);
    }
  }

  setData() {
    var user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((data) {
      setState(() {
        unamecontrol.text = data['uname'].toString();
        statuscontrol.text = data['status'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Text("VCHAT");
                }
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(124, 36, 65, 109),
                          borderRadius: BorderRadius.circular(35)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        child: Text(
                          snapshot.data['uname'].toString().toUpperCase(),
                          style: TextStyle(fontSize: 16),
                        ),
                      )),
                );
              },
            ),
            Expanded(
                child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: () {
                    addImgData();
                  },
                  icon: Icon(CupertinoIcons.cloud_upload_fill)),
            ))
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color.fromARGB(255, 71, 110, 219),
                    Color.fromARGB(255, 116, 30, 185)
                  ], begin: Alignment.bottomLeft, end: Alignment.topRight),
                  color: Color.fromRGBO(11, 27, 51, 1),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: Center(
                child: InkWell(
                  onTap: () {
                    selectImage();
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 0),
                              spreadRadius: 50,
                              blurRadius: 70)
                        ],
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 61, 104, 212),
                              Color.fromRGBO(0, 204, 191, 1)
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight),
                        color: Colors.amber,
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(120)),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user!.uid)
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }
                        return setProfileImg(snapshot.data['img'].toString());
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                          blurRadius: 10)
                    ],
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(35)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return LinearProgressIndicator();
                      }
                      return Text((snapshot.data['email'].toString()));
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: TextFormField(
                controller: statuscontrol,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Enter Your Status",
                  labelText: "Status",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: InkWell(
                onTap: () {
                  updateData();
                },
                child: Container(
                  width: 100,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 62, 206, 67),
                      borderRadius: BorderRadius.circular(45)),
                  child: Center(
                    child: Text(
                      "Update",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
