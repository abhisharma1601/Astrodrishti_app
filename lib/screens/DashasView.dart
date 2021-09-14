import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashasView extends StatefulWidget {
  DashasView({required this.m, required this.a});
  String m, a;

  @override
  _DashasViewState createState() => _DashasViewState();
}

List<antartext> _antartextwids = [];
List<DashaWid> _mahadashas = [];

class _DashasViewState extends State<DashasView> {
  getd() {
    _mahadashas = [];
    for (int i = 0; i < 9; i++) {
      _antartextwids = [];
      for (int j = 0; j < 9; j++) {
        _antartextwids.add(
          antartext(
            txt: jsonDecode(widget.a)["response"]["antardashas"][i][j]
                .toString()
                .replaceAll("/", " - "),
          ),
        );
      }
      _mahadashas.add(
        DashaWid(
          name: jsonDecode(widget.m)["response"]["mahadasha"][i],
          time:
              jsonDecode(widget.m)["response"]["mahadasha_order"][i].toString(),
          antarwids: _antartextwids,
        ),
      );

      // print(
      //     "${jsonDecode(widget.m)["response"]["mahadasha"][i]}---->till ${jsonDecode(widget.m)["response"]["mahadasha_order"][i].toString()}\n");
      // for (int j = 0; j < 9; j++) {
      //   _antartextwids.add(
      //     antartext(
      //       txt: jsonDecode(widget.a)["response"]["antardashas"][i][j]
      //           .toString()
      //           .replaceAll("/", " - "),
      //     ),
      //   );

      // }

    }

    setState(() {});
  }

  @override
  void initState() {
    getd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _mahadashas),
      ),
    );
  }
}

class DashaWid extends StatelessWidget {
  DashaWid({required this.name, required this.time, required this.antarwids});

  String name, time;
  List<antartext> antarwids = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "$name",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                "(Till $time) :",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(70, 5, 0, 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: antarwids),
          )
        ],
      ),
    );
  }
}

class antartext extends StatelessWidget {
  antartext({required this.txt});

  String txt;

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
    );
  }
}
