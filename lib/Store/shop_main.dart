import 'dart:async';
import 'dart:convert';

import 'package:astrodrishti_app/Store/report_page.dart';
import 'package:astrodrishti_app/Store/askquestion.dart';
import 'package:astrodrishti_app/screens/dailyhoroscope.dart';
import 'package:astrodrishti_app/screens/dataentry.dart';
import 'package:astrodrishti_app/sidescreens/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/painting.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

import '../startpage.dart';

class Shop extends StatefulWidget {
  Shop({required this.email});
  String email;
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  bool spin = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> checkbanner() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection("Users")
          .doc("emails")
          .collection(currentuser.passemail())
          .doc("Data")
          .get();
      if (!(snap.data() as dynamic)["question_1"]) {
        showbanner(1);
      } else {
        showbanner(2);
      }
    } catch (e) {
      showbanner(1);
    }
  }

  Future<void> showbanner(val) async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection("AppData")
          .doc("ad_post")
          .get();
      Timer.run(() => contest((snap.data() as dynamic)["url$val"]));
    } catch (e) {
      //Timer.run(() => contest());
    }
  }

  void contest(url) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AskQuestion()));
              },
              child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(url), fit: BoxFit.scaleDown),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: null),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.amberAccent[700],
        title: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
            child: Text(
              "AstroDrishti Shop".tr(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.065,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: ModalProgressHUD(
        opacity: 0.0,
        inAsyncCall: spin,
        progressIndicator: RefreshProgressIndicator(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                setState(() {
                  spin = true;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => report_entry(),
                  ),
                );
                setState(() {
                  spin = false;
                });
              },
              child: Container(
                height: 190,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amberAccent.shade700),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage("images/report.jpg"),
                      fit: BoxFit.fitWidth),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  spin = true;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AskQuestion(),
                  ),
                );
                setState(() {
                  spin = false;
                });
              },
              child: Container(
                height: 190,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amberAccent.shade700),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage("images/que.png"),
                      fit: BoxFit.fitWidth),
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                launch("https://stackx.online");
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Center(
                    child: Text(
                  "By StackX",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PageBox extends StatelessWidget {
  PageBox({required this.name, required this.txt1, required this.txt2});
  String name, txt1, txt2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 6),
        Image.asset("images/$name.jpg",
            height: MediaQuery.of(context).size.height * 0.17),
        SizedBox(height: 6),
        Text(
          txt1,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        SizedBox(height: 1),
        Text(
          txt2,
          style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 10,
              color: Colors.amberAccent[700]),
        ),
        SizedBox(height: 2),
      ],
    );
  }
}
