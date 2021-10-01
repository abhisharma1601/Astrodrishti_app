import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class orderst extends StatefulWidget {
  orderst({required this.email});
  String email;

  @override
  _orderstState createState() => _orderstState();
}

List<Widget> orderlist = [];

class _orderstState extends State<orderst> {
  Future<void> fetchorders() async {
    orderlist = [];
    var snap = await FirebaseFirestore.instance
        .collection("Users")
        .doc("Orders")
        .collection(widget.email)
        .get();
    for (var i in snap.docs) {
      orderlist.add(orderbox(
          name: i.data()["Name"],
          date: i.data()["DOB"],
          id: i.data()["Order ID"].toString(),
          state: i.data()["Pay_id"],
          urll: i.data()["url"],
          type: i.data()["Type"]));
    }
    setState(() {
      print(orderlist);
    });
  }

  @override
  void initState() {
    fetchorders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.amberAccent[700],
        title: Text(
          "orders".tr(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: orderlist),
      ),
    );
  }
}

class orderbox extends StatefulWidget {
  orderbox(
      {required this.name,
      required this.date,
      required this.id,
      required this.state,
      required this.urll,
      required this.type});
  String name = "null", date = "null", id = "null", state, urll, type;

  @override
  _orderboxState createState() => _orderboxState();
}

class _orderboxState extends State<orderbox> {
  IconData icc = Icons.file_download;
  double prc = 10.00;

  _launchURL() async {
    var url = '${widget.urll}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (ctx) => bottomsheet(
                      orderid: widget.id,
                      name: widget.name,
                      urle: widget.urll,
                      dob: widget.date,
                      state: widget.state,
                      perc: prc,
                      type: widget.type,
                    ));
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amberAccent.shade700)),
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${"orderid".tr()} : ${widget.id}",
                        style: TextStyle(
                            color: Colors.amberAccent[700],
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 3),
                    Row(
                      children: <Widget>[
                        Text(widget.name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.normal)),
                        SizedBox(width: 7),
                        Text("{ ${widget.date} }",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    _launchURL();
                  },
                  child: Icon(
                    icc,
                    color: Colors.amberAccent[700],
                    size: 35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class bottomsheet extends StatelessWidget {
  bottomsheet(
      {required this.orderid,
      required this.perc,
      required this.name,
      required this.dob,
      required this.state,
      required this.type,
      required this.urle});
  String orderid, name, dob, state, type, urle;
  double perc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        border: Border.all(color: Colors.amberAccent.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text("${"orderid".tr()} : $orderid",
                style: TextStyle(
                    color: Colors.amberAccent[700],
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${"name".tr()} : $name",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.normal)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("DOB : $dob",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.normal)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${"Payment ID".tr()} $state",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.normal)),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text("Status".tr(),
                style: TextStyle(
                    color: Colors.amberAccent[700],
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  if (await canLaunch(urle)) {
                    print("22");
                    launch(urle);
                  } else {
                    throw 'Could not launch $urle';
                  }
                },
                child: Container(
                  height: 45,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.amberAccent.shade700,
                      ),
                      color: Colors.black),
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          "Download".tr(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Text(
                          " ${type.tr()}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
