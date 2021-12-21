import 'package:astrodrishti_app/brain/wids.dart';
import 'package:astrodrishti_app/Store/askquestion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:share/share.dart';
import '../../startpage.dart';

import 'account.dart';
import 'blogs.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_switch/flutter_switch.dart';

import 'order_status.dart';
import 'savedkundlis.dart';

const String testDevice = "mobile_id";

class drawer extends StatefulWidget {
  @override
  _drawerState createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  @override
  _launchURL() async {
    const url = 'https://4abhi45.github.io/astrodrishtiapp/services.html';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget build(BuildContext context) {
    bool _spin = false;

    return ModalProgressHUD(
      opacity: 0.1,
      inAsyncCall: _spin,
      progressIndicator: RefreshProgressIndicator(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: Colors.amberAccent.shade700,
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.032,
              45,
              0,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.12,
                  backgroundImage: AssetImage("images/lg.jpg"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 3, 0, 10),
                  child: Text(
                    "AstroDrishti 卐".tr(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.084,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 18, 18, 18),
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => acc_page(
                        imgurl: currentuser.passpic(),
                        email: currentuser.passemail(),
                        name: currentuser.passname(),
                      ),
                    ),
                  );
                });
              },
              child: Drawer_wig(
                icon: Icons.account_circle,
                text: "Acc".tr(),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 18, 18),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    _spin = true;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              orderst(email: currentuser.passemail())));
                  setState(() {
                    _spin = false;
                  });
                },
                child: Drawer_wig(
                  icon: Icons.local_mall,
                  text: "orders".tr(),
                ),
              )),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(10, 10, 18, 18),
          //   child: GestureDetector(
          //     onTap: () async {
          //       String email = currentuser.passemail();
          //       try {
          //         var snap = await FirebaseFirestore.instance
          //             .collection("FreeAnalysis")
          //             .where("email", isEqualTo: email)
          //             .get();
          //         print(snap.docs.first.id);
          //         entrysub();
          //       } catch (e) {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => free_analysis(email: email)));
          //       }
          //     },
          //     child: Drawer_wig(
          //       icon: Icons.analytics,
          //       text: "Freeanalysis".tr(),
          //     ),
          //   ),
          // ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 18, 18),
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    _spin = true;
                  });
                  String email = currentuser.passemail();
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

                  setState(() {
                    _spin = false;
                  });
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>sv_kundli(email: email)));
                },
                child: Drawer_wig(
                  icon: Icons.save,
                  text: "saved".tr(),
                ),
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 18, 18),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _spin = true;
                  });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AskQuestion()));
                  setState(() {
                    _spin = false;
                  });
                },
                child: Drawer_wig(
                  icon: Icons.question_answer,
                  text: "Ask Astrologer".tr(),
                ),
              )),
          Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 18, 18),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _spin = true;
                  });
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => web_vv()));
                  setState(() {
                    _spin = false;
                  });
                },
                child: Drawer_wig(
                  icon: Icons.book,
                  text: "Blogs".tr(),
                ),
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 18, 18),
            child: GestureDetector(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _spin = true;
                  });
                  Share.share(
                      'Download our App AstroDrishti which guides you and tells you what is best and what not in life ahead to make it comfortable. https://play.google.com/store/apps/details?id=in.astrodrishti.app');
                  setState(() {
                    _spin = false;
                  });
                },
                child: Drawer_wig(
                  icon: Icons.share,
                  text: "share".tr(),
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 18),
          //   child: Row(
          //     children: [
          //       Icon(
          //         Icons.language,
          //         size: 25,
          //         color: Colors.amberAccent[700],
          //       ),
          //       SizedBox(
          //         width: 10,
          //       ),
          //       FlutterSwitch(
          //         width: 70.0,
          //         height: 35.0,
          //         valueFontSize: 10.0,
          //         toggleSize: 25.0,
          //         value: currentuser.passlan(),
          //         borderRadius: 30.0,
          //         padding: 8.0,
          //         showOnOff: true,
          //         inactiveText: "हिंदी",
          //         activeText: "Eng",
          //         activeColor: Colors.black,
          //         inactiveColor: Colors.black,
          //         onToggle: (val) {
          //           setState(() {
          //             _spin = true;
          //             currentuser.language = val;
          //             if (val == false) {
          //               context.setLocale(Locale("en", "US"));
          //             } else {
          //               context.setLocale(Locale("hi", "IN"));
          //             }
          //             _spin = false;
          //           });
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          Spacer(),
          GestureDetector(
            onTap: () {
              launch("https://stackx.online");
            },
            child: Center(
                child: Text(
              "By StackX",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 12),
            )),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
