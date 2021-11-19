import 'dart:convert';

import 'package:astrodrishti_app/Store/astrologers.dart';
import 'package:astrodrishti_app/brain/location_picker.dart';
import 'package:astrodrishti_app/brain/payment.dart';
import 'package:astrodrishti_app/brain/wids.dart';
import 'package:astrodrishti_app/cubit/astrocubit_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../startpage.dart';

class AskQuestion extends StatefulWidget {
  AskQuestion();
  @override
  _AskQuestionState createState() => _AskQuestionState();
}

int _ansp = answerprice;
late int ofsp = 0;
int astro_id = 0;

class _AskQuestionState extends State<AskQuestion> {
  @override
  void initState() {
    // set_answerprice();
    getoff();
    super.initState();
    astro_id = 0;
    BlocProvider.of<AstrocubitCubit>(context).update_Name("Select Astrologer");
    checknet();
  }

  Future<void> getoff() async {
    var key = await FirebaseFirestore.instance
        .collection("AppData")
        .doc("APIKEY")
        .get();
    ofsp = (key.data() as dynamic)["Offer_Price"];
  }

  // ignore: non_constant_identifier_names
  // Future<void> set_answerprice() async {
  //   try {
  //     var snap = await FirebaseFirestore.instance
  //         .collection("Users")
  //         .doc("emails")
  //         .collection(currentuser.passemail())
  //         .doc("Data")
  //         .get();
  //     if (!(snap.data() as dynamic)["question_1"]) {
  //       var key = await FirebaseFirestore.instance
  //           .collection("AppData")
  //           .doc("APIKEY")
  //           .get();

  //       _ansp = (key.data() as dynamic)["Offer_Price"];
  //     } else {
  //       _ansp = answerprice;
  //     }
  //   } catch (e) {
  //     var key = await FirebaseFirestore.instance
  //         .collection("AppData")
  //         .doc("APIKEY")
  //         .get();

  //     _ansp = (key.data() as dynamic)["Offer_Price"];
  //   }
  // }

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
  late Map _pickedLocation;
  var _pickedLocationText;
  TextEditingController _textEditingController = TextEditingController();
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
    return BlocBuilder<AstrocubitCubit, AstrocubitState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: GestureDetector(
            onTap: () {
              if (_textEditingController.text.replaceAll(" ", "") != "" &&
                  _textEditingController.text != null) {
                if (astro_id != 0) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 16,
                            child: Container(
                              height: 400,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.amberAccent.shade700)),
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      print(_ansp);
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => py_pg(
                                                    que: _textEditingController
                                                        .text,
                                                    lat: lat,
                                                    lon: lon,
                                                    dob: datei,
                                                    bt: timei,
                                                    type: "Question",
                                                    astro_id: astro_id,
                                                    name:
                                                        currentuser.passname(),
                                                    pricee: _ansp,
                                                  )));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color:
                                                  Colors.amberAccent.shade700),
                                          color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Full Explanation",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Price: $_ansp/-",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "In this your question will be answered in detail with remedies. Astrologer will talk about your dashas, planets and future prespective. Astrologer will provide you best support remedies for your future.",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print(ofsp);
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => py_pg(
                                                    que: _textEditingController
                                                        .text,
                                                    lat: lat,
                                                    lon: lon,
                                                    dob: datei,
                                                    bt: timei,
                                                    type: "Question",
                                                    astro_id: astro_id,
                                                    name:
                                                        currentuser.passname(),
                                                    pricee: ofsp,
                                                  )));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color:
                                                  Colors.amberAccent.shade700),
                                          color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Small Explanation",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Price: $ofsp/-",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "In this your question will be answered in detail without remedies. Astrologer will talk about your current dasha only. Astrologer will provide you best prediction for your query.",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => py_pg(
                  //               que: _textEditingController.text,
                  //               lat: lat,
                  //               lon: lon,
                  //               dob: datei,
                  //               bt: timei,
                  //               type: "Question",
                  //               astro_id: astro_id,
                  //               name: currentuser.passname(),
                  //               pricee: _ansp,
                  //             )));
                } else {
                  Fluttertoast.showToast(
                      msg: "Select Your Astrologer!".tr(),
                      textColor: Colors.black,
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.white);
                }
              } else {
                Fluttertoast.showToast(
                    msg: "Fill Full Form !".tr(),
                    textColor: Colors.black,
                    toastLength: Toast.LENGTH_LONG,
                    backgroundColor: Colors.white);
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.078,
              width: MediaQuery.of(context).size.width * 0.28,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.amberAccent.shade700),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.send,
                    color: Colors.black,
                    size: MediaQuery.of(context).size.width * 0.078,
                  ),
                  SizedBox(height: 3),
                  Text(
                    "Register Question".tr(),
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  )
                ],
              ),
            ),
          ),
          backgroundColor: Colors.black,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.amberAccent[700],
            title: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                child: Text(
                  "Ask Question".tr(),
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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 19, 16, 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _textEditingController,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: new InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: "Type You Question Here.....".tr(),
                        hintStyle: TextStyle(color: Colors.black, fontSize: 20),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                          onTap: () async {
                            await showDatePicker(
                              context: context,
                              initialDate:
                                  datee == null ? DateTime.now() : datee,
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
                                datei =
                                    "${datee.day}/${datee.month}/${datee.year}";
                              });
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(15, 5, 4, 5),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.amberAccent.shade700),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "DOB: " + datei,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.044,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          )),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await showTimePicker(
                                  context: context, initialTime: timee)
                              .then((time) => timee = time!);
                          setState(() {
                            timei = timee.toString().substring(10, 15);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(4, 5, 15, 5),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.amberAccent.shade700),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Bt".tr() + timei,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.043,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      spin = true;
                    });
                    await getLocationWithNominatim();
                    http.Response res = await http.get(
                      Uri.parse(
                          "https://us1.locationiq.com/v1/reverse.php?key=4b811c0bc86e19&lat=$lat&lon=$lon&format=json"),
                    );

                    http.Response ress = await http.get(
                      Uri.parse(
                          "http://api.timezonedb.com/v2.1/get-time-zone?key=0MX7YDAS3D26&format=json&by=position&lat=$lat&lng=$lon"),
                    );
                    setState(() {
                      if (jsonDecode(res.body)["address"]["city"] == null) {
                        if (jsonDecode(res.body)["address"]["village"] ==
                            null) {
                          loca = jsonDecode(res.body)["address"]["town"]
                                  .toString() +
                              ", " +
                              jsonDecode(res.body)["address"]["state"]
                                  .toString() +
                              ", " +
                              jsonDecode(res.body)["address"]["country"]
                                  .toString();
                        } else {
                          loca = jsonDecode(res.body)["address"]["village"]
                                  .toString() +
                              ", " +
                              jsonDecode(res.body)["address"]["state"]
                                  .toString() +
                              ", " +
                              jsonDecode(res.body)["address"]["country"]
                                  .toString();
                        }
                      } else {
                        if (jsonDecode(res.body)["address"]["state"] == null) {
                          loca = jsonDecode(res.body)["address"]["city"]
                                  .toString() +
                              ", " +
                              jsonDecode(res.body)["address"]["country"]
                                  .toString();
                        } else {
                          loca = jsonDecode(res.body)["address"]["city"]
                                  .toString() +
                              ", " +
                              jsonDecode(res.body)["address"]["state"]
                                  .toString() +
                              ", " +
                              jsonDecode(res.body)["address"]["country"]
                                  .toString();
                        }
                      }
                      loca = loca.replaceAll("null", "");
                      tmz = (json.decode(ress.body)['gmtOffset'].toInt() / 3600)
                          .toString();
                      tmzdata =
                          (json.decode(ress.body)['gmtOffset'].toInt() / 3600)
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
                    margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
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
                // Container(
                //   margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                //   padding: EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.amberAccent.shade700),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Text(
                //     "Tmz".tr() + tmzdata,
                //     style: TextStyle(
                //       fontSize: MediaQuery.of(context).size.width * 0.047,
                //       color: Colors.white.withOpacity(0.5),
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Astrologers()));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.amberAccent.shade700),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      BlocProvider.of<AstrocubitCubit>(context)
                          .state
                          .astrologer_Name,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.047,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
