import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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
        backgroundColor: Colors.amberAccent[700],
        title: Text(
          "Daily Horoscope",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(10),
        height: 600,
        width: 400,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: Text(
                  widget.date,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Horobox(sign: "Aries", txt: "   Aries     "),
                Horobox(sign: "Libra", txt: "    Libra    "),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Horobox(sign: "Virgo", txt: "   Virgo   "),
                Horobox(sign: "Sagittarius", txt: "Sagittarius"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Horobox(
                  sign: "Aquarius",
                  txt: "  Aquarius ",
                ),
                Horobox(sign: "Pisces", txt: "   Pisces  "),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Horobox(
                  sign: "Gemini",
                  txt: "   Gemini  ",
                ),
                Horobox(
                  sign: "Taurus",
                  txt: "   Taurus  ",
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Horobox(
                  sign: "Leo",
                  txt: "     Leo     ",
                ),
                Horobox(
                  sign: "Scorpio",
                  txt: "  Scorpio  ",
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Horobox(
                  sign: "Capricorn",
                  txt: " Capricorn ",
                ),
                Horobox(
                  sign: "Cancer",
                  txt: "   Cancer  ",
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
  Horobox({required this.sign, required this.txt});
  String sign;
  String txt;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        http.Response rest = await http
            .get(Uri.parse("http://horoscope-api.herokuapp.com/horoscope/today/$sign"));
        String dat = jsonDecode(rest.body)['horoscope'];
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              elevation: 16,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text(
                      sign,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      dat,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
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
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.amberAccent),
        ),
        child: Text(
          txt,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
