import 'package:astrodrishti_app/Store/askquestion.dart';
import 'package:astrodrishti_app/brain/wids.dart';
import 'package:astrodrishti_app/cubit/astrocubit_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          i.data()["CAPQ"] < 12 &&
          roundDouble(i.data()["Total_Rating"] / i.data()["Ratings"], 2) ==
              5.0) {
        astrologers.add(Astrologer_Wid(
            dis: i.data()["Disc"],
            name: i.data()["Name"],
            rate: i.data()["Total_Rating"] / i.data()["Ratings"],
            exp: i.data()["Experience"],
            pic: i.data()["Pic"],
            id: i.data()["astro_id"]));
      } else {}
    }
    for (var i in key.docs) {
      if (i.data()["Status"] &&
          i.data()["CAPQ"] < 12 &&
          roundDouble(i.data()["Total_Rating"] / i.data()["Ratings"], 2) >= 4 &&
          roundDouble(i.data()["Total_Rating"] / i.data()["Ratings"], 2) < 5) {
        astrologers.add(Astrologer_Wid(
            name: i.data()["Name"],
            dis: i.data()["Disc"],
            rate: i.data()["Total_Rating"] / i.data()["Ratings"],
            exp: i.data()["Experience"],
            pic: i.data()["Pic"],
            id: i.data()["astro_id"]));
      } else {}
    }
    for (var i in key.docs) {
      if (i.data()["Status"] &&
          i.data()["CAPQ"] < 12 &&
          roundDouble(i.data()["Total_Rating"] / i.data()["Ratings"], 2) >= 3 &&
          roundDouble(i.data()["Total_Rating"] / i.data()["Ratings"], 2) < 4) {
        astrologers.add(Astrologer_Wid(
            dis: i.data()["Disc"],
            name: i.data()["Name"],
            rate: i.data()["Total_Rating"] / i.data()["Ratings"],
            exp: i.data()["Experience"],
            pic: i.data()["Pic"],
            id: i.data()["astro_id"]));
      } else {}
    }
    for (var i in key.docs) {
      if (i.data()["Status"] &&
          i.data()["CAPQ"] < 12 &&
          roundDouble(i.data()["Total_Rating"] / i.data()["Ratings"], 2) >= 2 &&
          roundDouble(i.data()["Total_Rating"] / i.data()["Ratings"], 2) < 3) {
        astrologers.add(Astrologer_Wid(
            dis: i.data()["Disc"],
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
      required this.dis,
      required this.id});
  String name, pic, dis;
  int exp, id;
  var rate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(id);
        BlocProvider.of<AstrocubitCubit>(context)
            .update_Name("Selected: $name");
        astro_id = id;
        Fluttertoast.showToast(msg: "Astrologer Selected");
        Navigator.pop(context);
      },
      child: Container(
        // height: 145,
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 47,
                  backgroundColor: Colors.amberAccent.shade700,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundImage: NetworkImage(pic),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "${roundDouble(rate, 2)}/5",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              width: 15,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$name",
                    style: TextStyle(
                        fontSize: 20,
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
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        width: 205,
                        height: 57,
                        child: SingleChildScrollView(
                          child: Text(
                            dis,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
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
