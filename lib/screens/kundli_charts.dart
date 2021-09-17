import 'package:astrodrishti_app/brain/wids.dart';
import 'package:astrodrishti_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:xml/xml.dart';

class Kundli_charts extends StatefulWidget {
  Kundli_charts(
      {required this.dob,
      required this.lat,
      required this.lon,
      required this.time,
      required this.tmz});

  String dob, lat, lon, time, tmz;

  @override
  _Kundli_chartsState createState() => _Kundli_chartsState();
}

class _Kundli_chartsState extends State<Kundli_charts> {
  @override
  void initState() {
    if (charts.length == 0) {
      getcharts();
    }
    super.initState();
  }

  bool spin = false;

  getcharts() async {
    setState(() {
      spin = true;
    });
    List chartslink = [];
    Uri urlimg = Uri.parse(
        "https://api.vedicastroapi.com/json/horoscope/chartimage?dob=${widget.dob}&tob=${widget.time}&lat=${widget.lat}&lon=${widget.lon}&tz=${widget.tmz}&div=D1&style=north&color=black&api_key=$keyy");
    http.Response chartimg = await http.get(urlimg);
    chartslink
        .add({"Lagna Chart": XmlDocument.parse(chartimg.body).toString()});
    Uri urlimg2 = Uri.parse(
        "https://api.vedicastroapi.com/json/horoscope/chartimage?dob=${widget.dob}&tob=${widget.time}&lat=${widget.lat}&lon=${widget.lon}&tz=${widget.tmz}&div=D9&style=north&color=black&api_key=$keyy");
    http.Response chartimg2 = await http.get(urlimg2);
    chartslink
        .add({"Navamsa Chart": XmlDocument.parse(chartimg2.body).toString()});
    for (var i in chartslink) {
      charts.add(Chart_Box(
          name: i.keys.toString().replaceAll("(", "").replaceAll(")", ""),
          img: i.values.toString()));
    }
    setState(() {
      spin = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.amberAccent[700],
      //   title: Text(
      //     "kd".tr(),
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontSize: 28,
      //     ),
      //   ),
      // ),
      body: ModalProgressHUD(
        opacity: 0.0,
        inAsyncCall: spin,
        progressIndicator: RefreshProgressIndicator(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: charts,
          ),
        ),
      ),
    );
  }
}

class Chart_Box extends StatelessWidget {
  Chart_Box({required this.name, required this.img});
  String name, img;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: SvgPicture.string(img),
        ),
        Text(
          name,
          style: TextStyle(color: Colors.amberAccent.shade700, fontSize: 25),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
