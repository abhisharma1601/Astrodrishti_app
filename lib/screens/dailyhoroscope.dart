import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class dailyhr extends StatefulWidget {
  dailyhr({required this.date});
  String date;

  @override
  _dailyhrState createState() => _dailyhrState();
}

class _dailyhrState extends State<dailyhr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.amberAccent[700],
        title: Text(
          "Daily Horoscope".tr(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Center(
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            //     child: Text(
            //       widget.date,
            //       style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 40,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Horobox(
                    sign: "Aries",
                    txt: "Aries".tr(),
                    url:
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Aries.svg/1200px-Aries.svg.png",
                  ),
                ),
                Expanded(
                  child: Horobox(
                    sign: "Libra",
                    txt: "Libra".tr(),
                    url:
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Libra.svg/1200px-Libra.svg.png",
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Horobox(
                      sign: "Virgo",
                      txt: "Virgo".tr(),
                      url:
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Virgo.svg/1200px-Virgo.svg.png"),
                ),
                Expanded(
                  child: Horobox(
                      sign: "Sagittarius",
                      txt: "Sagittarius".tr(),
                      url:
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/Sagittarius.svg/1200px-Sagittarius.svg.png"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Horobox(
                    sign: "Aquarius",
                    txt: "Aquarius".tr(),
                    url:
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/Aquarius.svg/1200px-Aquarius.svg.png",
                  ),
                ),
                Expanded(
                  child: Horobox(
                      sign: "Pisces",
                      txt: "Pisces".tr(),
                      url:
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Pisces.svg/1200px-Pisces.svg.png"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Horobox(
                      sign: "Gemini",
                      txt: "Gemini".tr(),
                      url:
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Gemini.svg/1200px-Gemini.svg.png"),
                ),
                Expanded(
                  child: Horobox(
                      sign: "Taurus",
                      txt: "Taurus".tr(),
                      url:
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Taurus.svg/1200px-Taurus.svg.png"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Horobox(
                      sign: "Leo",
                      txt: "Leo".tr(),
                      url:
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/9/99/Leo.svg/1200px-Leo.svg.png"),
                ),
                Expanded(
                  child: Horobox(
                      sign: "Scorpio",
                      txt: "Scorpio".tr(),
                      url:
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Scorpio.svg/1200px-Scorpio.svg.png"),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Horobox(
                      sign: "Capricorn",
                      txt: "Capricorn".tr(),
                      url:
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/Capricorn.svg/1200px-Capricorn.svg.png"),
                ),
                Expanded(
                  child: Horobox(
                      sign: "Cancer",
                      txt: "Cancer".tr(),
                      url:
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/2/29/Cancer.svg/1200px-Cancer.svg.png"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Horobox extends StatelessWidget {
  Horobox({required this.sign, required this.txt, required this.url});
  String sign;
  String txt;
  String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        http.Response rest = await http.get(Uri.parse(
            "http://horoscope-api.herokuapp.com/horoscope/today/$sign"));
        String dat = jsonDecode(rest.body)['horoscope'];
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 16,
              child: Container(
                height: 500,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amberAccent.shade700)),
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text(
                      sign,
                      style: TextStyle(
                          color: Colors.amberAccent.shade700,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      dat,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        //height: 164,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.amberAccent),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image(height: 90, image: NetworkImage(url)),
            ),
            Text(
              txt,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
