import 'package:astrodrishti_app/brain/wids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class update_page extends StatefulWidget {
  @override
  _update_pageState createState() => _update_pageState();
}

class _update_pageState extends State<update_page> {
  String _link = "";

  @override
  void initState() {
    getup();
    super.initState();
  }

  getup() async {
    var linkdata = await FirebaseFirestore.instance
        .collection("AppData")
        .doc("update")
        .get();
    _link = (linkdata.data() as dynamic)["link"];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            "images/lg.jpg",
            height: 150,
            width: 150,
          ),
          GestureDetector(
            onTap: () async {
              if (await canLaunch(_link)) {
                launch(_link);
              } else {
                throw 'Could not launch';
              }
            },
            child: Container(
              margin: EdgeInsets.all(55),
              height: 65,
              width: 175,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.amberAccent.shade700,
                  ),
                  color: Colors.black),
              child: Center(
                child: Text(
                  "Update App",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              "As New version of our app is out, Please download it from above button. New Features are added and bugs are fixed in new apk. Thank you",
              style: TextStyle(
                  color: Colors.amberAccent[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
