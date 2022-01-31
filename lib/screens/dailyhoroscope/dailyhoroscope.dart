import 'dart:convert';
import 'package:astrodrishti_app/brain/wids.dart';
import 'package:astrodrishti_app/cubit/astrocubit_cubit.dart';
import 'package:astrodrishti_app/screens/dailyhoroscope/displayscreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

bool _this = false;

class dailyhr extends StatefulWidget {
  dailyhr({required this.date});
  String date;

  @override
  _dailyhrState createState() => _dailyhrState();
}

class _dailyhrState extends State<dailyhr> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AstrocubitCubit, AstrocubitState>(
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: BlocProvider.of<AstrocubitCubit>(context).state.progress,
          opacity: 0,
          progressIndicator:
              CircularProgressIndicator(color: Colors.amberAccent.shade700),
          child: Scaffold(
            backgroundColor: Colors.black,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Horobox(
                          sign: "1",
                          txt: "Aries".tr(),
                        ),
                      ),
                      Expanded(
                        child: Horobox(
                          sign: "7",
                          txt: "Libra".tr(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Horobox(
                          sign: "6",
                          txt: "Virgo".tr(),
                        ),
                      ),
                      Expanded(
                        child: Horobox(
                          sign: "9",
                          txt: "Sagittarius".tr(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Horobox(
                          sign: "11",
                          txt: "Aquarius".tr(),
                        ),
                      ),
                      Expanded(
                        child: Horobox(
                          sign: "12",
                          txt: "Pisces".tr(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Horobox(
                          sign: "3",
                          txt: "Gemini".tr(),
                        ),
                      ),
                      Expanded(
                        child: Horobox(
                          sign: "2",
                          txt: "Taurus".tr(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Horobox(
                          sign: "5",
                          txt: "Leo".tr(),
                        ),
                      ),
                      Expanded(
                        child: Horobox(
                          sign: "8",
                          txt: "Scorpio".tr(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Horobox(
                          sign: "10",
                          txt: "Capricorn".tr(),
                        ),
                      ),
                      Expanded(
                        child: Horobox(
                          sign: "4",
                          txt: "Cancer".tr(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
        BlocProvider.of<AstrocubitCubit>(context).set_progress(true);
        String day = await DateTime.now().day.toString().length == 1
            ? "0${DateTime.now().day.toString()}"
            : DateTime.now().day.toString();
        String month = await DateTime.now().month.toString().length == 1
            ? "0${DateTime.now().month.toString()}"
            : DateTime.now().month.toString();
        print("$day/$month/${DateTime.now().year}");
        http.Response rest = await http.get(Uri.parse(
            "https://api.vedicastroapi.com/json/prediction/dailysun?zodiac=$sign&show_same=true&date=${"$day/$month/${DateTime.now().year}"}&type=big&api_key=$keyy"));
        http.Response rest1 = await http.get(Uri.parse(
            "https://api.vedicastroapi.com/json/prediction/weeklysun?zodiac=$sign&show_same=true&week=thisweek&type=big&api_key=$keyy"));

        String dat = jsonDecode(rest.body)["response"]['bot_response'];
        String datw = jsonDecode(rest1.body)["response"]['bot_response'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HoroscopeDisplay(dailyData: dat, weeklyData: datw, name: txt),
          ),
        );
        BlocProvider.of<AstrocubitCubit>(context).set_progress(false);
      },
      child: Container(
        //height: 164,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/gradient_horo.jpg"), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.amberAccent),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image(
                  height: 120, image: AssetImage("images/signs/$txt.png")),
            ),
            // Text(
            //   txt,
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontWeight: FontWeight.bold,
            //     fontSize: 22,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
