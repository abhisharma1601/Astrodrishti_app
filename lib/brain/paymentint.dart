import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
//nothing 

class finalpage extends StatelessWidget {
  finalpage({required this.head, required this.body, required this.pyt});
  String head, body, pyt;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent[700],
        title: Text(
          "Payment Info".tr(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
          ),
        ),
      ),
      body: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          height: 600,
          width: 400,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 10, 20),
                child: Text(
                  head,
                  style: TextStyle(
                      color: Colors.amberAccent[700],
                      fontSize: 42,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 30),
                child: Text(
                  body,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 60, 10, 20),
                child: Text(
                  pyt,
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 42,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )),
    );
  }
}
