import 'dart:convert';

import 'package:astrodrishti_app/brain/brain.dart';
import 'package:astrodrishti_app/brain/wids.dart';
import 'package:astrodrishti_app/screens/DashasView.dart';
import 'package:astrodrishti_app/screens/planetinfo.dart';
import 'package:astrodrishti_app/screens/kundli_charts.dart';

import 'package:astrodrishti_app/screens/resultpage.dart';
import 'package:astrodrishti_app/startpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

class KundliMenu extends StatefulWidget {
  KundliMenu(
      {required this.planets,
      required this.name,
      required this.dob,
      required this.time,
      required this.timezone,
      required this.lat,
      required this.lon,
      required this.place});
  List planets;
  String name;
  String dob;
  String time;
  String timezone;
  String lat, lon, place;

  @override
  _KundliMenuState createState() => _KundliMenuState();
}

class _KundliMenuState extends State<KundliMenu> {
  bool spin = false;
  int index = 0;
  List<Widget> widlist = [
    Container(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  void initState() {
    charts = [];
    savevis = true;
    widlist[1] = Kundli_charts(
        dob: widget.dob,
        lat: widget.lat,
        lon: widget.lon,
        time: widget.time,
        tmz: widget.timezone);
    getplanets();
    getbasic();
    getdata();
    getdashas();
    super.initState();
  }

  getdashas() async {
    http.Response resm = await http.get(Uri.parse(
        "https://api.vedicastroapi.com/json/horoscope/mahadasha?dob=${widget.dob}&tob=${widget.time}&lat=${widget.lat}&lon=${widget.lon}&tz=${widget.timezone}&api_key=$keyy"));
    String datam = await resm.body;

    http.Response resa = await http.get(Uri.parse(
        "https://api.vedicastroapi.com/json/horoscope/antardasha?dob=${widget.dob}&tob=${widget.time}&lat=${widget.lat}&lon=${widget.lon}&tz=${widget.timezone}&api_key=$keyy"));
    String dataa = await resa.body;   
    setState(() {
      widlist[3] = DashasView(m: datam, a: dataa);
    });
  }

  getbasic() async {
    List<Widget> tablelistlocal = [];
    tablelistlocal.add(
      New_Tables(heading: "Basic Details".tr(), tablelist: [
        TableRow(
          children: [table_text(text: "name".tr()), table_text(text: widget.name)],
        ),
        TableRow(
          children: [
            table_text(text: "DOB".tr()),
            table_text(text: widget.dob.toString())
          ],
        ),
        TableRow(
          children: [
            table_text(text: "Bt".tr()),
            table_text(text: widget.time.toString())
          ],
        ),
        TableRow(
          children: [
            table_text(text: "Loc".tr()),
            table_text(text: widget.place.toString())
          ],
        ),
      ]),
    );
    http.Response res = await http.get(Uri.parse(
        "https://api.vedicastroapi.com/json/panchang/getpanchang?date=${widget.dob}&time=${widget.time}&tz=${widget.timezone}&api_key=$keyy"));
    String data = res.body;
    var datadecode = jsonDecode(data)["response"];
    tablelistlocal.add(
      New_Tables(
        heading: "Kundli Details".tr(),
        tablelist: [
          TableRow(children: [
            table_text(text: "Day".tr()),
            table_text(text: datadecode["day"]["name"])
          ]),
          TableRow(children: [
            table_text(text: "Tithi".tr()),
            table_text(text: datadecode["tithi"]["name"])
          ]),
          TableRow(children: [
            table_text(text: "Nakshatra".tr()),
            table_text(text: datadecode["nakshatra"]["name"])
          ]),
          TableRow(children: [
            table_text(text: "Karna".tr()),
            table_text(text: datadecode["karna"]["name"])
          ]),
          TableRow(children: [
            table_text(text: "Yoga".tr()),
            table_text(text: datadecode["yoga"]["name"])
          ]),
          TableRow(children: [
            table_text(text: "Rashi".tr()),
            table_text(text: datadecode["rasi"]["name"])
          ]),
        ],
      ),
    );
    widlist[0] = Basicdetails(tablelist: tablelistlocal);
    setState(() {});
  }

  getplanets() async {
    List<TableRow> planetsdeg = [];
    http.Response res = await http.get(Uri.parse(
        "https://api.vedicastroapi.com/json/horoscope/vedic?dob=${widget.dob}&tob=${widget.time}&lat=${widget.lat}&lon=${widget.lon}&tz=${widget.timezone}&api_key=$keyy"));
    String data = await res.body;
    //List deglist = [];
    for (var i = 0; i < 10; i++) {
      try {
        planetsdeg.add(TableRow(children: [
          table_text(
              text: jsonDecode(data)['response'][i.toString()]['full_name']
                  .toString()
                  .tr()),
          table_text(
              text: jsonDecode(data)['response'][i.toString()]['local_degree']
                  .toString()
                  .substring(0, 5))
        ]));
      } on Exception {
        break;
      }
    }
    widlist[2] = Basicdetails(tablelist: [
      New_Tables(tablelist: planetsdeg, heading: "Planet Degree".tr())
    ]);
    setState(() {});
  }

  getdata() async {
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
    widlist[4] = result_page(
        pp: pp,
        lat: widget.lat,
        lon: widget.lon,
        perso: perso,
        name: widget.name,
        dob: widget.dob,
        bt: widget.time,
        sun: brn.sunn(),
        moon: brn.monn(),
        areport: brn.ar(),
        mercury: brn.mercuryy(),
        mars: brn.marss(),
        saturn: brn.marss(),
        venus: brn.venuss(),
        lagan: brn.lgnr(),
        jupiter: brn.jupiterr());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          backgroundColor: Colors.amberAccent.shade700,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          onTap: (val) {
            setState(() {
              index = val;
              if (val == 4) {
                savevis = false;
              } else
                savevis = true;
            });
          },
          items: [
            BottomNavigationBarItem(
              label: "Details",
              icon: Icon(Icons.notes),
            ),
            BottomNavigationBarItem(
              label: "Charts",
              icon: Icon(Icons.table_chart),
            ),
            BottomNavigationBarItem(
              label: "Planets",
              icon: Icon(Icons.wb_sunny),
            ),
            BottomNavigationBarItem(
                label: "Dashas",
                icon: Icon(
                  Icons.timelapse,
                )),
            BottomNavigationBarItem(
              label: "Prediction",
              icon: Icon(Icons.batch_prediction),
            ),
          ]),
      floatingActionButton: GestureDetector(
        onTap: () {
          FirebaseFirestore.instance
              .collection("Users")
              .doc("emails")
              .collection(currentuser.email)
              .doc(widget.name)
              .set({
            "Name": widget.name,
            "DOB": widget.dob,
            "Birthtime": widget.time,
            "planets": widget.planets,
            "lat": widget.lat,
            "lon": widget.lon,
            "timezone": widget.timezone
          });
          Fluttertoast.showToast(msg: "Kundli Saved!");
        },
        child: Visibility(
          visible: savevis,
          child: CircleAvatar(
            backgroundColor: Colors.amberAccent.shade700,
            radius: 30,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 28,
              child: Icon(
                Icons.save,
                color: Colors.white,
                size: 35,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent[700],
        title: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
            child: Text(
              "AstroDrishti 卐".tr(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.070,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: widlist[index],
      // body: ModalProgressHUD(
      //   opacity: 0.0,
      //   inAsyncCall: spin,
      //   progressIndicator: RefreshProgressIndicator(),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     children: [
      //       SizedBox(height: 10),
      //       GestureDetector(
      //         onTap: () async {
      //           setState(() {
      //             spin = true;
      //           });
      //           List charts = [];
      //           Uri urlimg = await Uri.parse(
      //               "https://api.vedicastroapi.com/json/horoscope/chartimage?dob=${widget.dob}&tob=${widget.time}&lat=${widget.lat}&lon=${widget.lon}&tz=${widget.timezone}&div=D1&style=north&color=black&api_key=$keyy");
      //           http.Response chartimg = await http.get(urlimg);
      //           charts.add({
      //             "Lagna Chart": XmlDocument.parse(chartimg.body).toString()
      //           });
      //           Uri urlimg2 = await Uri.parse(
      //               "https://api.vedicastroapi.com/json/horoscope/chartimage?dob=${widget.dob}&tob=${widget.time}&lat=${widget.lat}&lon=${widget.lon}&tz=${widget.timezone}&div=D9&style=north&color=black&api_key=$keyy");
      //           http.Response chartimg2 = await http.get(urlimg2);
      //           charts.add({
      //             "Navamsa Chart": XmlDocument.parse(chartimg2.body).toString()
      //           });
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) =>
      //                       Kundli_charts(chartslist: charts)));
      //           setState(() {
      //             spin = false;
      //           });
      //         },
      //         child: Container(
      //           padding: EdgeInsets.symmetric(
      //               vertical: MediaQuery.of(context).size.height * 0.03),
      //           margin: EdgeInsets.only(bottom: 10),
      //           decoration: BoxDecoration(
      //               border: Border.all(color: Colors.amberAccent.shade700),
      //               borderRadius: BorderRadius.circular(10)),
      //           child: Center(
      //             child: Column(
      //               children: [
      //                 Text(
      //                   "Kundli Charts",
      //                   style: TextStyle(
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.bold,
      //                       fontSize: 20),
      //                 ),
      //                 SizedBox(
      //                   height: 5,
      //                 ),
      //                 Text(
      //                   "Various charts related to your birthdata",
      //                   style: TextStyle(
      //                       color: Colors.amberAccent.shade700,
      //                       fontWeight: FontWeight.normal,
      //                       fontSize: 13),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //       Container(
      //         padding: EdgeInsets.symmetric(
      //             vertical: MediaQuery.of(context).size.height * 0.03),
      //         margin: EdgeInsets.only(bottom: 10),
      //         decoration: BoxDecoration(
      //             border: Border.all(color: Colors.amberAccent.shade700),
      //             borderRadius: BorderRadius.circular(10)),
      //         child: Center(
      //           child: Column(
      //             children: [
      //               Text(
      //                 "Basic Detials",
      //                 style: TextStyle(
      //                     color: Colors.white,
      //                     fontWeight: FontWeight.bold,
      //                     fontSize: 20),
      //               ),
      //               SizedBox(
      //                 height: 5,
      //               ),
      //               Text(
      //                 "Some details related to birthdate",
      //                 style: TextStyle(
      //                     color: Colors.amberAccent.shade700,
      //                     fontWeight: FontWeight.normal,
      //                     fontSize: 13),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       Container(
      //         padding: EdgeInsets.symmetric(
      //             vertical: MediaQuery.of(context).size.height * 0.03),
      //         margin: EdgeInsets.only(bottom: 10),
      //         decoration: BoxDecoration(
      //             border: Border.all(color: Colors.amberAccent.shade700),
      //             borderRadius: BorderRadius.circular(10)),
      //         child: Center(
      //           child: Column(
      //             children: [
      //               Text(
      //                 "Planet Degree's",
      //                 style: TextStyle(
      //                     color: Colors.white,
      //                     fontWeight: FontWeight.bold,
      //                     fontSize: 20),
      //               ),
      //               SizedBox(
      //                 height: 5,
      //               ),
      //               Text(
      //                 "See how effective is a planet ?",
      //                 style: TextStyle(
      //                     color: Colors.amberAccent.shade700,
      //                     fontWeight: FontWeight.normal,
      //                     fontSize: 13),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       Container(
      //         padding: EdgeInsets.symmetric(
      //             vertical: MediaQuery.of(context).size.height * 0.03),
      //         margin: EdgeInsets.only(bottom: 10),
      //         decoration: BoxDecoration(
      //             border: Border.all(color: Colors.amberAccent.shade700),
      //             borderRadius: BorderRadius.circular(10)),
      //         child: Center(
      //           child: Column(
      //             children: [
      //               Text(
      //                 "Mahadashas",
      //                 style: TextStyle(
      //                     color: Colors.white,
      //                     fontWeight: FontWeight.bold,
      //                     fontSize: 20),
      //               ),
      //               SizedBox(
      //                 height: 5,
      //               ),
      //               Text(
      //                 "Time period of a planet's effect",
      //                 style: TextStyle(
      //                     color: Colors.amberAccent.shade700,
      //                     fontWeight: FontWeight.normal,
      //                     fontSize: 13),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       GestureDetector(
      //         onTap: () async {
      //           setState(() {
      //             spin = true;
      //           });
      //           analyzeapi braindata = analyzeapi(
      //               date: widget.dob,
      //               time: widget.time,
      //               lata: widget.lat,
      //               longa: widget.lon);
      //           var data = await braindata.miniapiwrk();
      //           await gogg();
      //           pre_brain brn = pre_brain(data: data, list: widget.planets);
      //           brn.set_lagnarashi();
      //           brn.givedegree();
      //           brn.givepos();
      //           brn.set_rashi();
      //           brn.fper();
      //           brn.ascendent();
      //           brn.areport();
      //           String pp = brn.fpsf();
      //           String perso = brn.perso();
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //               builder: (context) => result_page(
      //                 pp: pp,
      //                 areport: brn.ar(),
      //                 sun: brn.sunn(),
      //                 moon: brn.monn(),
      //                 venus: brn.venuss(),
      //                 saturn: brn.saturnn(),
      //                 lagan: brn.lgnr(),
      //                 mars: brn.marss(),
      //                 mercury: brn.mercuryy(),
      //                 jupiter: brn.jupiterr(),
      //                 perso: perso,
      //                 lat: widget.lat,
      //                 lon: widget.lon,
      //                 name: widget.name,
      //                 dob: widget.dob,
      //                 bt: widget.time,
      //               ),
      //             ),
      //           );
      //           setState(() {
      //             spin = false;
      //           });
      //         },
      //         child: Container(
      //           padding: EdgeInsets.symmetric(
      //               vertical: MediaQuery.of(context).size.height * 0.03),
      //           margin: EdgeInsets.only(bottom: 10),
      //           decoration: BoxDecoration(
      //               border: Border.all(color: Colors.amberAccent.shade700),
      //               borderRadius: BorderRadius.circular(10)),
      //           child: Center(
      //             child: Column(
      //               children: [
      //                 Text(
      //                   "Analysis",
      //                   style: TextStyle(
      //                       color: Colors.white,
      //                       fontWeight: FontWeight.bold,
      //                       fontSize: 20),
      //                 ),
      //                 SizedBox(
      //                   height: 5,
      //                 ),
      //                 Text(
      //                   "What your kundli chart tells ?",
      //                   style: TextStyle(
      //                       color: Colors.amberAccent.shade700,
      //                       fontWeight: FontWeight.normal,
      //                       fontSize: 13),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
