// @dart=2.9
import 'dart:ffi';

import 'package:astrodrishti_app/update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sidescreens/loading.dart';
import 'startpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';

int version = 1;

String hemlo = "";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('hi', 'IN')],
      path: 'Assets',
      fallbackLocale: Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    checkupdate();
    super.initState();
  }

  Widget startpage = loading();

  Future<void> checkupdate() async {
    var snap = await FirebaseFirestore.instance
        .collection("AppData")
        .doc("update")
        .get();
    int ver = (snap.data() as dynamic)["Version"];
    if (version >= ver) {
      setState(() {
        startpage = start_page();
      });
    } else if (version != ver) {
      setState(() {
        startpage = update_page();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        // textTheme: GoogleFonts.aBeeZeeTextTheme(
        //   Theme.of(context).textTheme,
        // ),
      ),
      home: startpage,
    );
  }
}
