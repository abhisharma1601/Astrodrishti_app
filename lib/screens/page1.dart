import 'dart:async';
import 'dart:convert';

import 'package:astrodrishti_app/Store/report_page.dart';
import 'package:astrodrishti_app/Store/shop_main.dart';
import 'package:astrodrishti_app/sidescreens/drawer.dart';
import 'package:astrodrishti_app/sidescreens/order_query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

import '../startpage.dart';
import '../Store/askquestion.dart';
import 'dailyhoroscope.dart';
import 'dataentry.dart';
import 'manglik.dart';
import 'moon.dart';
import 'pitradosh.dart';
import 'sun.dart';

class page1 extends StatefulWidget {
  page1({required this.email});
  String email;
  @override
  _page1State createState() => _page1State();
}

class _page1State extends State<page1> {
  bool spin = false;

  @override
  void initState() {
    checkbanner();
    notify();
    super.initState();
  }

  void notify() {
    //when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message!.notification != null) {
        if (message.notification!.title == "Order Updated") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => order_query(
                      url:
                          "https://stackx1617.herokuapp.com/orderquery?OID=${message.data["OID"]}")));
        }
      }
    });

    //foreground message
    FirebaseMessaging.onMessage.listen((message) {
      print("helo!");
      if (message.notification != null) {
        print(message.notification!.body);
        Fluttertoast.showToast(msg: message.notification!.body as String);
      }
    });

    //background taps
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.notification!.title as String);
      print(message.notification!.body);
      if (message.notification!.title == "Order Updated") {
        print("Hello");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => order_query(
                    url:
                        "https://stackx1617.herokuapp.com/orderquery?OID=${message.data["OID"]}")));
      }
    });
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
      // floatingActionButton: GestureDetector(
      //   onTap: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (context) => AskQuestion()));
      //   },
      //   child: CircleAvatar(
      //     backgroundColor: Colors.amberAccent[700],
      //     radius: MediaQuery.of(context).size.width * 0.08,
      //     child: CircleAvatar(
      //       radius: MediaQuery.of(context).size.width * 0.075,
      //       backgroundColor: Colors.white,
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Center(
      //           child: Icon(
      //             Icons.chat,
      //             color: Colors.black,
      //             size: MediaQuery.of(context).size.width * 0.088,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      drawer: Drawer(
        child: drawer(),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.amberAccent[700],
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            "AstroDrishti".tr(),
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.065,
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Shop(email: currentuser.passemail())));
              },
              child: Icon(
                Icons.shopping_cart,
                color: Colors.black,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: ModalProgressHUD(
          opacity: 0.0,
          inAsyncCall: spin,
          progressIndicator: RefreshProgressIndicator(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          spin = true;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => data_entry()));
                        setState(() {
                          spin = false;
                        });
                      },
                      child: Container(
                        //height: MediaQuery.of(context).size.height * 0.27,
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.amberAccent.shade700),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: PageBox(
                          name: "kundli",
                          txt1: "Kundli Analysis".tr(),
                          txt2: "Chart, Planets and Prediction".tr(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          spin = true;
                        });
                        http.Response rest = await http.get(Uri.parse(
                            "http://horoscope-api.herokuapp.com/horoscope/today/Capricorn"));
                        String dat = jsonDecode(rest.body)["date"];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => dailyhr(
                                      date: dat,
                                    )));
                        setState(() {
                          spin = false;
                        });
                      },
                      child: Container(
                        //height: MediaQuery.of(context).size.height * 0.27,
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.amberAccent.shade700),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: PageBox(
                          name: "daily",
                          txt1: "Daily Horoscope".tr(),
                          txt2: "Check what your sign says".tr(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          spin = true;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AskQuestion()));
                        setState(() {
                          spin = false;
                        });
                      },
                      child: Container(
                        //height: MediaQuery.of(context).size.height * 0.27,
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.amberAccent.shade700),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: PageBox(
                          name: "consult",
                          txt1: "Conuslt Now".tr(),
                          txt2: "Ask the expert for right advice.".tr(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          spin = true;
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => report_entry()));
                        setState(() {
                          spin = false;
                        });
                      },
                      child: Container(
                        //height: MediaQuery.of(context).size.height * 0.27,
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.amberAccent.shade700),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: PageBox(
                          name: "report",
                          txt1: "Kundli Report".tr(),
                          txt2: "Get full kundli report".tr(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          spin = true;
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => manglik()));
                        setState(() {
                          spin = false;
                        });
                      },
                      child: Container(
                        //height: MediaQuery.of(context).size.height * 0.27,
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.amberAccent.shade700),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: PageBox(
                          name: "mars",
                          txt1: "Mangal Dosha".tr(),
                          txt2: "Manglik or not ?".tr(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          spin = true;
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => pitr()));
                        setState(() {
                          spin = false;
                        });
                      },
                      child: Container(
                        //height: MediaQuery.of(context).size.height * 0.27,
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.amberAccent.shade700),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: PageBox(
                          name: "pitr",
                          txt1: "Pitra Dosha".tr(),
                          txt2: "kundli has Pitra Dosha or not ?".tr(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          spin = true;
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => sun()));
                        setState(() {
                          spin = false;
                        });
                      },
                      child: Container(
                        //height: MediaQuery.of(context).size.height * 0.27,
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.amberAccent.shade700),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: PageBox(
                          name: "sun",
                          txt1: "Sun Sign ?".tr(),
                          txt2: "Check Your Sunsign".tr(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          spin = true;
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => moon()));
                        setState(() {
                          spin = false;
                        });
                      },
                      child: Container(
                        //height: MediaQuery.of(context).size.height * 0.27,
                        padding: EdgeInsets.all(6),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.amberAccent.shade700),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: PageBox(
                          name: "moon",
                          txt1: "Moon Sign ?".tr(),
                          txt2: "Check Your Moonsign".tr(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
