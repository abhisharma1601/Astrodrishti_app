import 'dart:async';
import 'dart:convert';

import 'package:astrodrishti_app/main.dart';
import 'package:astrodrishti_app/screens/KundliMenu.dart';
import 'package:astrodrishti_app/screens/kundlipage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:xml/xml.dart';

class api {
  api({
    required this.time,
    required this.lat,
    required this.long,
    required this.date,
    required this.timezone,
  });

  String date;
  String lat;
  String long;
  String timezone;
  String time;

  Future apiwrk() async {
    try {
      Uri url = await Uri.parse(
          "https://api.vedicastroapi.com/json/horoscope/vedic?dob=$date&tob=$time&lat=$lat&lon=$long&tz=$timezone&api_key=$keyy");
      Uri urlimg = await Uri.parse(
          "https://api.vedicastroapi.com/json/horoscope/chartimage?dob=$date&tob=$time&lat=$lat&lon=$long&tz=$timezone&div=D1&style=north&color=black&api_key=$keyy");
      http.Response resimg = await http.get(urlimg);
      http.Response res = await http.get(url);
      print("gogo");
      //print(resimg.body);
      print(XmlDocument.parse(resimg.body).findAllElements("svg"));

      // .findAllElements("svg")
      // .toString()
      // .replaceAll("(", "")
      // .replaceAll(")", "");
      String data = res.body;
      // print(jsonDecode(data)["response"]);
      List palnets = ["", "", "", "", "", "", "", "", "", "", "", "", "", ""];
      List houseno = ["", "", "", "", "", "", "", "", "", "", "", "", ""];
      List deglist = [];
      for (var i = 0; i < 10; i++) {
        try {
          int x = jsonDecode(data)['response'][i.toString()]['house'];
          //print(x);
          palnets[x] = await palnets[x] +
              " " +
              jsonDecode(data)["response"][i.toString()]['full_name'];
          deglist.add({
            jsonDecode(data)['response'][i.toString()]['full_name']:
                jsonDecode(data)['response'][i.toString()]['local_degree']
          });
        } on Exception {
          break;
        }
      }
      int no = jsonDecode(data)["response"]["0"]['rasi_no'];
      palnets[1] = "        " +
          "(" +
          jsonDecode(data)["response"]["0"]['rasi_no'].toString() +
          ")" +
          "\n" +
          palnets[1];
      palnets[13] = no;
      houseno[1] = no;
      int k = 1;
      for (var j = 2; j < 13; j++) {
        if (no < 12) {
          no++;
          houseno[j] = houseno[j - 1] + 1;
        } else {
          // houseno[j]=no-(j-1);
          for (var m = 0; m < 1; m++) {
            houseno[j] = k;
            k++;
          }
        }
      }
      //print(palnets+houseno);
      List new_list = palnets + houseno;

      //print(new_list);
      return [new_list, deglist];
    } catch (e) {
      print("22");
    }
  }
}

class chotabox extends StatelessWidget {
  chotabox({required this.planet});
  String planet;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.fromLTRB(7, 0, 7, 7),
        height: 54,
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(
            planet,
            style: TextStyle(fontSize: 11, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class Txtfld extends StatelessWidget {
  Txtfld({required this.txt, required this.contro});

  String txt;
  TextEditingController contro;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: contro,
      autocorrect: true,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.amberAccent.shade700,
      decoration: InputDecoration(
        labelText: txt,
        labelStyle: TextStyle(color: Colors.grey),
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.amberAccent.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.amberAccent.shade700),
        ),
      ),
    );
  }
}

class Drawer_wig extends StatelessWidget {
  Drawer_wig({required this.icon, required this.text});
  IconData icon;
  String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: MediaQuery.of(context).size.width * 0.062,
          color: Colors.amberAccent[700],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.032, 0, 0, 0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.042,
            ),
          ),
        )
      ],
    );
  }
}

class analyzeapi {
  analyzeapi(
      {required this.date,
      required this.time,
      required this.lata,
      required this.longa});

  String lata;
  String longa;
  String date;
  String time;

  Future miniapiwrk() async {
    http.Response res = await http.get(Uri.parse(
        "https://api.vedicastroapi.com/json/horoscope/vedic?dob=$date&tob=$time&lat=$lata&lon=$longa&tz=5.5&api_key=$keyy"));
    String data = res.body;
    return data;
  }
}

class Pre_box extends StatelessWidget {
  Pre_box({
    required this.head,
    required this.body,
  });
  String head = null as String;
  String body = null as String;
  String name = null as String,
      dob = null as String,
      bp = null as String,
      bt = null as String,
      lat = null as String,
      lon = null as String;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12, 8, 12, 4),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Text(head,
                  style: TextStyle(
                      //decoration: TextDecoration.underline,
                      color: Colors.amberAccent[700],
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Column(
                children: <Widget>[
                  Text(body,
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class svbox extends StatelessWidget {
  svbox({
    required this.data,
    required this.dob,
    required this.email,
    required this.planets,
    required this.time,
    required this.lat,
    required this.lon,
    required this.tmz,
    required this.name,
  });
  String data = "No data Saved";
  String dob = "No data saved";
  List planets;
  String time;
  String lat, lon;
  String tmz;
  String email, name;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => KundliMenu(
                    planets: planets,
                    name: name,
                    dob: dob,
                    time: time,
                    timezone: tmz,
                    lat: lat,
                    place:
                        "Lat: ${lat.substring(0, 5)}, Long: ${lon.substring(0, 5)}",
                    lon: lon)));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
        height: 40,
        width: 500,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: <Widget>[
            Text(
              " " + data + " ",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            Text(
              "(" + dob + ")",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    await FirebaseFirestore.instance
                        .collection("Users")
                        .doc("emails")
                        .collection(email)
                        .doc(data)
                        .delete();
                  },
                  child: Icon(
                    Icons.delete,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

String keyy = null as String;
int reportprice = null as int, answerprice = null as int;
String keyrz = null as String;
String gkey = null as String;
List<Widget> charts = [];
bool savevis = true;
String link = "";

gogg() async {
  var api_key_main = await FirebaseFirestore.instance
      .collection("AppData")
      .doc("APIKEY")
      .get();

  keyy = (api_key_main.data() as dynamic)["key"];
  reportprice = (api_key_main.data() as dynamic)["price"];
  answerprice = (api_key_main.data() as dynamic)["question price"];
  keyrz = (api_key_main.data() as dynamic)["keyrz"];
  gkey = (api_key_main.data() as dynamic)["google_key"];
}

final formdone = () => Fluttertoast.showToast(
    msg: "Entry Submitted !",
    textColor: Colors.black,
    backgroundColor: Colors.white);

final fullform = () => Fluttertoast.showToast(
    msg: "Fill Full Form !".tr(),
    textColor: Colors.black,
    backgroundColor: Colors.white);

final savedalready = () => Fluttertoast.showToast(
    msg: "Kundli With same Name exists !".tr(),
    textColor: Colors.black,
    backgroundColor: Colors.white);

final entrysub = () => Fluttertoast.showToast(
    msg: "Entry already submitted !",
    textColor: Colors.black,
    backgroundColor: Colors.white);
final saved = () => Fluttertoast.showToast(
    msg: "Kundli Saved !".tr(),
    textColor: Colors.black,
    backgroundColor: Colors.white);

final nonet = () => Fluttertoast.showToast(
    msg: "No Internet !",
    textColor: Colors.black,
    backgroundColor: Colors.white);
