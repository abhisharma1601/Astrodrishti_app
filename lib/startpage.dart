import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nice_button/nice_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:easy_localization/easy_localization.dart';
import 'brain/userdata.dart';
import 'brain/wids.dart';
import 'screens/page1.dart';

late UserData currentuser;

class start_page extends StatefulWidget {
  @override
  _start_pageState createState() => _start_pageState();
}

class _start_pageState extends State<start_page> {
  @override
  void initState() {
    checknet();
    super.initState();
  }

  void checknet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      login();
    } else {
      nonet();
    }
  }

  late bool language;

  Future<void> login() async {
    setState(() {
      show = true;
    });
    await gogg();
    GoogleSignIn gs = GoogleSignIn(scopes: ['email']);
    GoogleSignInAccount? google_user = await gs.signIn();
    GoogleSignInAuthentication googleAuth = await google_user!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    User? user = authResult.user;
    try {
      context.setLocale(Locale("en", "US"));
      language = false;
      // var lan = await FirebaseFirestore.instance
      //     .collection("Users")
      //     .doc("emails")
      //     .collection(user!.email as String)
      //     .doc("AAAAAA")
      //     .get();
      // language = (lan.data() as dynamic)["Lan Bool"];
      // if (language) {
      //   context.setLocale(Locale("hi", "IN"));
      // } else if (!language) {
      //   context.setLocale(Locale("en", "US"));
      // }
    } catch (e) {
      context.setLocale(Locale("en", "US"));
      language = false;
    }

    currentuser = UserData(
        email: user!.email as String,
        pic: user.photoURL as String,
        name: user.displayName as String,
        language: language);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => page1(
                  email: currentuser.passemail(),
                )));
    setState(() {
      show = false;
    });
  }

  @override
  bool show = false;

  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/AD.gif"), fit: BoxFit.cover),
        ),
        child: ModalProgressHUD(
          opacity: 0.0,
          inAsyncCall: show,
          progressIndicator: RefreshProgressIndicator(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  login();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 450, 0, 0),
                      // ignore: missing_required_param
                      child: NiceButton(
                        //mini: true,
                        width: 180,
                        radius: 20,
                        text: "start".tr(),
                        textColor: Colors.orange,
                        fontSize: 28,
                        icon: Icons.arrow_forward_ios,
                        iconColor: Colors.red,
                        gradientColors: [Colors.red, Colors.deepOrange],
                        background: Color.fromRGBO(38, 38, 38, 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
