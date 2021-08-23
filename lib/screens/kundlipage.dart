import 'package:astrodrishti_app/brain/brain.dart';
import 'package:astrodrishti_app/brain/wids.dart';
import 'package:astrodrishti_app/main.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:easy_localization/easy_localization.dart';

import '../startpage.dart';
import 'resultpage.dart';

class kundli_page extends StatefulWidget {
  kundli_page(
      {required this.planets,
      required this.name,
      required this.dob,
      required this.place,
      required this.time,
      required this.timezone,
      required this.lat,
      required this.lon,
      required this.degreeslist});
  List planets, degreeslist;
  String name;
  String dob;
  String place;
  String time;
  String timezone;
  String lat, lon;

  @override
  _kundli_pageState createState() => _kundli_pageState();
}

class _kundli_pageState extends State<kundli_page> {
  @override
  bool spin = false;
  List<Widget> degbox = [];

  @override
  void initState() {
    super.initState();
   
    for (Map i in widget.degreeslist) {
      degbox.add(Deg_Box(
          name: i.keys.toString().replaceAll("(", "").replaceAll(")", ""),
          val: i.values
              .toString()
              .replaceAll("(", "")
              .replaceAll(")", "")
              .substring(0, 5)));
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    List<Widget> widsofswiper = [
      Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(color: Colors.white),
          child: SvgPicture.string(hemlo))
      // Container(
      //   height: 325,
      //   width: 300,
      //   margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
      //   decoration: BoxDecoration(
      //       image: DecorationImage(image: AssetImage("images/kundli11.jpg")),
      //       border: Border.all(color: Colors.white)),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Row(
      //         children: <Widget>[
      //           chotabox(
      //               planet: " " +
      //                   "(" +
      //                   (widget.planets[16]).toString() +
      //                   ")" +
      //                   "\n" +
      //                   widget.planets[2]),
      //           chotabox(
      //               planet: " " +
      //                   "(" +
      //                   (widget.planets[26]).toString() +
      //                   ")" +
      //                   "\n" +
      //                   widget.planets[12]),
      //         ],
      //       ),
      //       Row(
      //         children: <Widget>[
      //           chotabox(
      //               planet: "  " +
      //                   "(" +
      //                   (widget.planets[17]).toString() +
      //                   ")" +
      //                   "\n" +
      //                   widget.planets[3]),
      //           chotabox(planet: widget.planets[1].toString()),
      //           chotabox(
      //               planet: " " +
      //                   "(" +
      //                   (widget.planets[25]).toString() +
      //                   ")" +
      //                   "\n" +
      //                   widget.planets[11].toString()),
      //         ],
      //       ),
      //       Row(
      //         children: <Widget>[
      //           chotabox(
      //               planet: "  " +
      //                   "(" +
      //                   (widget.planets[18]).toString() +
      //                   ")" +
      //                   "\n" +
      //                   widget.planets[4].toString()),
      //           chotabox(
      //               planet: "  " +
      //                   "(" +
      //                   (widget.planets[24]).toString() +
      //                   ")" +
      //                   "\n" +
      //                   widget.planets[10].toString()),
      //         ],
      //       ),
      //       Row(
      //         children: <Widget>[
      //           chotabox(
      //               planet: "" +
      //                   "(" +
      //                   (widget.planets[19]).toString() +
      //                   ")" +
      //                   "\n" +
      //                   widget.planets[5].toString()),
      //           chotabox(
      //               planet: "  " +
      //                   "(" +
      //                   (widget.planets[21]).toString() +
      //                   ")" +
      //                   "\n" +
      //                   widget.planets[7].toString()),
      //           chotabox(
      //               planet: "  " +
      //                   "(" +
      //                   (widget.planets[23]).toString() +
      //                   ")" +
      //                   "\n" +
      //                   widget.planets[9].toString())
      //         ],
      //       ),
      //       Row(
      //         children: <Widget>[
      //           chotabox(
      //               planet: "        " +
      //                   "(" +
      //                   (widget.planets[20]).toString() +
      //                   ")" +
      //                   "\n" +
      //                   widget.planets[6]),
      //           chotabox(
      //               planet: "        " +
      //                   "(" +
      //                   (widget.planets[22]).toString() +
      //                   ")" +
      //                   "\n" +
      //                   widget.planets[8]),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
      ,
      Container(
        margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        padding: EdgeInsets.all(5),
        //height: 390,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(0)),
        child: SingleChildScrollView(
          child: Column(
            children: degbox,
          ),
        ),
      )
    ];
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent[700],
        title: Text(
          "kd".tr(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
          ),
        ),
      ),
      body: ModalProgressHUD(
        opacity: 0.0,
        inAsyncCall: spin,
        progressIndicator: RefreshProgressIndicator(),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 450,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return widsofswiper[index];
                  },
                  itemCount: 2,
                  pagination: new SwiperPagination(),
                  control: new SwiperControl(),
                ),
              ),
              SizedBox(
                height: 40,
                // width: 50,
                child: Divider(
                  color: Colors.white,
                ),
              ),
              // Container(
              //   margin: EdgeInsets.fromLTRB(22, 0, 0, 5),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children: <Widget>[
              //       Row(
              //         children: <Widget>[
              //           Text(
              //             "Data".tr(),
              //             style: TextStyle(
              //                 fontSize: 40,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.white),
              //           ),
              //         ],
              //       ),
              //       Text(
              //         widget.name,
              //         style: TextStyle(fontSize: 20, color: Colors.white),
              //       ),
              //       Text(
              //         widget.dob,
              //         style: TextStyle(fontSize: 20, color: Colors.white),
              //       ),
              //       Text(
              //         widget.place,
              //         style: TextStyle(fontSize: 20, color: Colors.white),
              //       )
              //     ],
              //   ),
              // ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    spin = true;
                  });
                  analyzeapi braindata = analyzeapi(
                      date: widget.dob,
                      time: widget.time,
                      lata: widget.lat,
                      longa: widget.lon);
                  var data = await braindata.miniapiwrk();
                  await gogg();
                  pre_brain brn = pre_brain(data: data, list: widget.planets);
                  brn.set_lagnarashi();
                  brn.givedegree();
                  brn.givepos();
                  brn.set_rashi();
                  brn.fper();
                  brn.ascendent();
                  brn.areport();
                  String pp = brn.fpsf();
                  String perso = brn.perso();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => result_page(
                        pp: pp,
                        areport: brn.ar(),
                        sun: brn.sunn(),
                        moon: brn.monn(),
                        venus: brn.venuss(),
                        saturn: brn.saturnn(),
                        lagan: brn.lgnr(),
                        mars: brn.marss(),
                        mercury: brn.mercuryy(),
                        jupiter: brn.jupiterr(),
                        perso: perso,
                        lat: widget.lat,
                        lon: widget.lon,
                        name: widget.name,
                        dob: widget.dob,
                        bt: widget.time,
                      ),
                    ),
                  );
                  setState(() {
                    spin = false;
                  });
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(22, 20, 5, 40),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent[700],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Center(
                          child: Text(
                            "analyze".tr(),
                            style: TextStyle(fontSize: 25, color: Colors.black),
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
                          String email = currentuser.passemail();
                          final snapShot = await FirebaseFirestore.instance
                              .collection("Users")
                              .doc("emails")
                              .collection(email)
                              .doc("AAAAAA")
                              .get();
                          if (snapShot.exists) {
                            final sp = await FirebaseFirestore.instance
                                .collection("Users")
                                .doc("emails")
                                .collection(email)
                                .doc(widget.name)
                                .get();
                            if (sp.exists) {
                              savedalready();
                              setState(() {
                                spin = false;
                              });
                            } else {
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc("emails")
                                  .collection(email)
                                  .doc(widget.name)
                                  .set({
                                "Name": widget.name,
                                "DOB": widget.dob,
                                "Birthtime": widget.time,
                                "birthplace": widget.place,
                                "lat": widget.lat,
                                "lon": widget.lon,
                                "timezone": widget.timezone,
                                "planets": widget.planets,
                                "deglist": widget.degreeslist
                              });
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc("emails")
                                  .collection(email)
                                  .doc("AAAAAA")
                                  .update({
                                "count": FieldValue.increment(1)
                              }).then((value) => saved());
                              setState(() {
                                spin = false;
                              });
                            }
                          } else {
                            final sn = await FirebaseFirestore.instance
                                .collection("Users")
                                .doc("emails")
                                .collection(email)
                                .doc(widget.name)
                                .get();
                            if (sn.exists) {
                              savedalready();
                              setState(() {
                                spin = false;
                              });
                            } else {
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc("emails")
                                  .collection(email)
                                  .doc("AAAAAA")
                                  .set({"count": 1});
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc("emails")
                                  .collection(email)
                                  .doc(widget.name)
                                  .set({
                                "Name": widget.name,
                                "DOB": widget.dob,
                                "Birthtime": widget.time,
                                "birthplace": widget.place,
                                "timezone": widget.timezone,
                                "lat": widget.lat,
                                "lon": widget.lon,
                                "planets": widget.planets,
                                "deglist": widget.degreeslist
                              });
                              await FirebaseFirestore.instance
                                  .collection("Users")
                                  .doc("emails")
                                  .collection(email)
                                  .doc("AAAAAA")
                                  .update({
                                "count": FieldValue.increment(1)
                              }).then((value) => saved());
                              setState(() {
                                spin = false;
                              });
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(5, 20, 20, 40),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white),
                          ),
                          child: Center(
                            child: Text(
                              "sv".tr(),
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
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
    );
  }
}

class Deg_Box extends StatelessWidget {
  Deg_Box({required this.name, required this.val});
  String name, val;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.amberAccent.shade700),
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(val,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }
}
