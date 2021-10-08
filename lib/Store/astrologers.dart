import 'package:astrodrishti_app/Store/askquestion.dart';
import 'package:astrodrishti_app/brain/wids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Astrologers extends StatefulWidget {
  const Astrologers({Key? key}) : super(key: key);

  @override
  _AstrologersState createState() => _AstrologersState();
}

class _AstrologersState extends State<Astrologers> {
  @override
  void initState() {
    Fluttertoast.showToast(msg: "Select your Astrologer.");
    getastros();
    super.initState();
  }

  List<Astrologer_Wid> astrologers = [];

  Future<void> getastros() async {
    astrologers = [];
    var key = await FirebaseFirestore.instance.collection("Astrologers").get();
    for (var i in key.docs) {
      if (i.data()["Status"] &&
          roundDouble(i.data()["Total_Rating"] / i.data()["Ratings"], 2) ==
              5.0) {
        astrologers.add(Astrologer_Wid(
            name: i.data()["Name"],
            rate: i.data()["Total_Rating"] / i.data()["Ratings"],
            exp: i.data()["Experience"],
            pic: i.data()["Pic"],
            id: i.data()["astro_id"]));
      } else {}
    }
    for (var i in key.docs) {
      if (i.data()["Status"] &&
          roundDouble(i.data()["Total_Rating"] / i.data()["Ratings"], 2) >= 4 &&
          roundDouble(i.data()["Total_Rating"] / i.data()["Ratings"], 2) < 5) {
        astrologers.add(Astrologer_Wid(
            name: i.data()["Name"],
            rate: i.data()["Total_Rating"] / i.data()["Ratings"],
            exp: i.data()["Experience"],
            pic: i.data()["Pic"],
            id: i.data()["astro_id"]));
      } else {}
    }
    for (var i in key.docs) {
      if (i.data()["Status"] &&
          roundDouble(i.data()["Total_Rating"] / i.data()["Ratings"], 2) >= 3 &&
          roundDouble(i.data()["Total_Rating"] / i.data()["Ratings"], 2) < 4) {
        astrologers.add(Astrologer_Wid(
            name: i.data()["Name"],
            rate: i.data()["Total_Rating"] / i.data()["Ratings"],
            exp: i.data()["Experience"],
            pic: i.data()["Pic"],
            id: i.data()["astro_id"]));
      } else {}
    }
    for (var i in key.docs) {
      if (i.data()["Status"] &&
          roundDouble(i.data()["Total_Rating"] / i.data()["Ratings"], 2) >= 2 &&
          roundDouble(i.data()["Total_Rating"] / i.data()["Ratings"], 2) < 3) {
        astrologers.add(Astrologer_Wid(
            name: i.data()["Name"],
            rate: i.data()["Total_Rating"] / i.data()["Ratings"],
            exp: i.data()["Experience"],
            pic: i.data()["Pic"],
            id: i.data()["astro_id"]));
      } else {}
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.amberAccent.shade700,
        title: Text("Our Astrologers", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Column(children: astrologers),
          ],
        ),
      ),
    );
  }
}

class Astrologer_Wid extends StatelessWidget {
  Astrologer_Wid(
      {required this.name,
      required this.exp,
      required this.rate,
      required this.pic,
      required this.id});
  String name, pic;
  int exp, id;
  var rate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        astro_id = id;
        Fluttertoast.showToast(msg: "Astrologer Selected");
        Navigator.pop(context);
      },
      child: Container(
        height: 135,
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amberAccent.shade700)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            CircleAvatar(
              radius: 57,
              backgroundColor: Colors.amberAccent.shade700,
              child: CircleAvatar(
                radius: 56,
                backgroundImage: NetworkImage(pic),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 30, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pt. $name",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 6),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Experience: $exp years",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Rating:   ${roundDouble(rate, 2)}/5",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
