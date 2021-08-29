import 'dart:convert';

import 'package:astrodrishti_app/brain/location_picker.dart';
import 'package:astrodrishti_app/brain/wids.dart';
import 'package:astrodrishti_app/main.dart';
import 'package:astrodrishti_app/screens/KundliMenu.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';

import 'kundlipage.dart';

class data_entry extends StatefulWidget {
  @override
  _data_entryState createState() => _data_entryState();
}

class _data_entryState extends State<data_entry> {
  @override
  void initState() {
    super.initState();
    checknet();
  }

  getLocationWithNominatim() async {
    var coors = await picloc(context);
    try {
      lat = coors[0];
      lon = coors[1];
    } catch (e) {
      lat = "28.70410001";
      lon = "77.10250001";
    }
  }

  void checknet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
    } else {
      nonet();
    }
  }

  @override
  bool spin = false;
  TextEditingController nameController = new TextEditingController();
  // late Map _pickedLocation;
  // var _pickedLocationText;
  //var geocoder = new Geocoder("652b38f6bdc04a62a89816aa15506b60");
  String loca = "Delhi, India";
  String lat = "28.70410001";
  String lon = "77.10250001", tmz = '5.5';
  String place = null as String, tmzdata = "5.5 ( India )";
  DateTime datee = DateTime.now();
  String datei =
      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
  TimeOfDay timee = TimeOfDay.now();
  String timei = TimeOfDay.now().toString().substring(10, 15);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent[700],
        title: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
            child: Text(
              "kdchart".tr(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
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
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
              child: Text(
                "enterdata".tr(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 15, 10),
              child: Txtfld(contro: nameController, txt: "ename".tr()),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: datee == null ? DateTime.now() : datee,
                          firstDate: DateTime(1501),
                          lastDate: DateTime(2221),
                        ).then((date) => {datee = date!});
                        if (datee.month.toString().length == 1 &&
                            datee.day.toString().length == 1) {
                          setState(() {
                            datei =
                                "0${datee.day}/0${datee.month}/${datee.year}";
                          });
                        } else if (datee.day.toString().length == 1) {
                          setState(() {
                            datei =
                                "0${datee.day}/${datee.month}/${datee.year}";
                          });
                        } else if (datee.month.toString().length == 1) {
                          setState(() {
                            datei =
                                "${datee.day}/0${datee.month}/${datee.year}";
                          });
                        } else {
                          setState(() {
                            datei = "${datee.day}/${datee.month}/${datee.year}";
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 4, 5),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.amberAccent.shade700),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "DOB: " + datei,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      )),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      await showTimePicker(context: context, initialTime: timee)
                          .then((time) => timee = time!);
                      setState(() {
                        timei = timee.toString().substring(10, 15);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(4, 5, 15, 5),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.amberAccent.shade700),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Bt".tr() + timei,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 0, 10),
              child: Text(
                "birthdetails".tr(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  spin = true;
                });
                await getLocationWithNominatim();
                http.Response res = await http.get(Uri.parse(
                    "https://us1.locationiq.com/v1/reverse.php?key=4b811c0bc86e19&lat=$lat&lon=$lon&format=json"));
                
                http.Response ress = await http.get(Uri.parse(
                    "http://api.timezonedb.com/v2.1/get-time-zone?key=0MX7YDAS3D26&format=json&by=position&lat=$lat&lng=$lon"));
                setState(() {
                  if (jsonDecode(res.body)["address"]["city"] == null) {
                    if (jsonDecode(res.body)["address"]["village"] == null) {
                      loca = jsonDecode(res.body)["address"]["town"]
                              .toString() +
                          ", " +
                          jsonDecode(res.body)["address"]["state"].toString() +
                          ", " +
                          jsonDecode(res.body)["address"]["country"].toString();
                    } else {
                      loca = jsonDecode(res.body)["address"]["village"]
                              .toString() +
                          ", " +
                          jsonDecode(res.body)["address"]["state"].toString() +
                          ", " +
                          jsonDecode(res.body)["address"]["country"].toString();
                    }
                  } else {
                    if (jsonDecode(res.body)["address"]["state"] == null) {
                      loca = jsonDecode(res.body)["address"]["city"]
                              .toString() +
                          ", " +
                          jsonDecode(res.body)["address"]["country"].toString();
                    } else {
                      loca = jsonDecode(res.body)["address"]["city"]
                              .toString() +
                          ", " +
                          jsonDecode(res.body)["address"]["state"].toString() +
                          ", " +
                          jsonDecode(res.body)["address"]["country"].toString();
                    }
                  }
                  loca = loca.replaceAll("null", "");
                  tmz = (json.decode(ress.body)['gmtOffset'].toInt() / 3600)
                      .toString();
                  tmzdata = (json.decode(ress.body)['gmtOffset'].toInt() / 3600)
                          .toString() +
                      " ( " +
                      jsonDecode(res.body)["address"]["country"] +
                      " ) ";
                });
                setState(() {
                  spin = false;
                });
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 5, 15, 10),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amberAccent.shade700),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Loc".tr() + loca,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 5, 15, 0),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amberAccent.shade700),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Tmz".tr() + tmzdata,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () async {
                if (nameController.text == "" || tmz == "") {
                  fullform();
                } else {
                  setState(() {
                    spin = true;
                  });
                  print(lat);
                  print(lon);
                  await gogg();
                  api kdap = api(
                    date: datei,
                    time: timei,
                    lat: lat,
                    long: lon,
                    timezone: tmz,
                  );
                  var data = await kdap.apiwrk();
                  
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KundliMenu(
                              planets: data[0],                              
                              time: timei,
                              name: nameController.text,
                              timezone: tmz,
                              lat: lat,
                              lon: lon, 
                              place: loca,                             
                              dob: datei)));

                
                  setState(() {
                    spin = false;
                  });
                }
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(14, 0, 15, 14),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.amberAccent[700],
                  borderRadius: BorderRadius.circular(6),
                  //border: Border.all(color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    "getknd".tr(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
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
