import 'package:astrodrishti_app/brain/wids.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class sv_kundli extends StatefulWidget {
  sv_kundli({required this.email, required this.lenn});
  String email;
  List<svbox> kdlist = [];
  int lenn;
  @override
  _sv_kundliState createState() => _sv_kundliState();
}

class _sv_kundliState extends State<sv_kundli> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent[700],
        title: Text(
          "SavedKundlis".tr(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc("emails")
              .collection(widget.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text("loading ...");
            for (var i = 1; i < widget.lenn; i++) {
              widget.kdlist.add(svbox(
                  email: widget.email,
                  lat: (snapshot.data as QuerySnapshot).docs[i]["lat"],
                  lon: (snapshot.data as QuerySnapshot).docs[i]["lon"],
                  deglist: (snapshot.data as QuerySnapshot).docs[i]["deglist"],
                  plc: (snapshot.data as QuerySnapshot).docs[i]["birthplace"],
                  planets: (snapshot.data as QuerySnapshot).docs[i]["planets"],
                  time: (snapshot.data as QuerySnapshot).docs[i]["Birthtime"],
                  tmz: (snapshot.data as QuerySnapshot).docs[i]["timezone"],
                  data: (snapshot.data as QuerySnapshot)
                      .docs[i]["Name"]
                      .toString(),
                  dob: (snapshot.data as QuerySnapshot)
                      .docs[i]["DOB"]
                      .toString()));
            }
            //print(widget.kdlist);
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.kdlist);
          },
        ),
      ),
    );
  }
}
