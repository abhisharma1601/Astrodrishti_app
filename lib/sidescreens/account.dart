import 'package:astrodrishti_app/brain/smtp.dart';
import 'package:astrodrishti_app/sidescreens/report_issue.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:share/share.dart';

import '../startpage.dart';
import 'about.dart';
import 'order_status.dart';
import 'package:easy_localization/easy_localization.dart';

import 'savedkundlis.dart';

class acc_page extends StatelessWidget {
  acc_page({required this.imgurl, required this.name, required this.email});
  String name = "No-login";
  String email = "No-login";
  String imgurl = "https://i.stack.imgur.com/34AD2.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        //backgroundColor: Colors.amberAccent[700],
        title: Text(
          "Account".tr(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.084,
                  backgroundImage: NetworkImage(imgurl)),
            ),
          ),
          Center(
              child: Text(
            name,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.04,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          )),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.pinkAccent,
                ),
                SizedBox(width: 5),
                Text(
                  email,
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                5, MediaQuery.of(context).size.height * 0.025, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    var lenofcount;
                    String email = currentuser.passemail();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => orderst(
                                  email: email,
                                )));
                  },
                  child: ac_wid(
                    title: "My Orders".tr(),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // final snapShot = await FirebaseFirestore.instance
                    //     .collection("Users")
                    //     .doc("emails")
                    //     .collection(currentuser.passemail())
                    //     .doc("AAAAAA")
                    //     .get();
                    // if (snapShot.exists) {
                    //   var lennn = await FirebaseFirestore.instance
                    //       .collection("Users")
                    //       .doc("emails")
                    //       .collection(email)
                    //       .doc("AAAAAA")
                    //       .get();
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => sv_kundli(
                    //                 email: email,
                    //               )));
                    // } else {
                    //print("get");
                    // FirebaseFirestore.instance
                    //     .collection("Users")
                    //     .doc("emails")
                    //     .collection(email)
                    //     .doc("AAAAAA")
                    //     .set({"count": 1});
                    // var lennn = await FirebaseFirestore.instance
                    //     .collection("Users")
                    //     .doc("emails")
                    //     .collection(email)
                    //     .doc("AAAAAA")
                    //     .get();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => sv_kundli(
                                  email: email,
                                )));
                  },
                  child: ac_wid(
                    title: "Saved Data".tr(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (contxet) => abt_view()));
                    },
                    child: ac_wid(title: "About App".tr())),
                GestureDetector(
                    onTap: () {
                       Navigator.push(context,
                          MaterialPageRoute(builder: (contxet) => Issue_Collector()));
                    }, child: ac_wid(title: "Report Issue".tr())),
                GestureDetector(
                    onTap: () {
                      Share.share(
                          'Download our App AstroDrishti which guides you and tells you what is best and what not in life ahead to make it comfortable. https://play.google.com/store/apps/details?id=in.astrodrishti.app');
                    },
                    child: ac_wid(title: "Share".tr())),
              ],
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              GoogleSignIn gs = GoogleSignIn(scopes: ['email']);
              gs.signOut();
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => start_page()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text("Sign Out".tr(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent))),
            ),
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}

class ac_wid extends StatelessWidget {
  ac_wid({required this.title});
  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.black),
      child: Text(
        title,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.025,
            fontWeight: FontWeight.normal,
            color: Colors.white),
      ),
    );
  }
}
