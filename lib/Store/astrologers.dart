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
    var key = await FirebaseFirestore.instance
        .collection("Astrologers")
        .orderBy("Total_Rating")
        .get();
    for (var i in key.docs.reversed) {
      if (i.data()["CAPQ"] < 15 &&
          i.data()['Status'] &&
          roundDouble(i.data()["Total_Rating"] / 1, 2) >= 3) {
        astrologers.add(Astrologer_Wid(
            dis: i.data()["Disc"],
            name: i.data()["Name"],
            rate: i.data()["Total_Rating"],
            exp: i.data()["Experience"],
            pic: i.data()["Pic"],
            id: i.data()["astro_id"]));
      }
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
        margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.height * 0.014,
            0,
            MediaQuery.of(context).size.height * 0.014,
            MediaQuery.of(context).size.height * 0.014),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amberAccent.shade700)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.013,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 6,
                ),
                CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.062,
                  backgroundColor: Colors.amberAccent.shade700,
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.059,
                    backgroundImage: NetworkImage(pic),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.008),
                Text(
                  "${roundDouble(rate / 1, 1)}/5",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.022,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 6,
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.017,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$name",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Experience: $exp years",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        width: 210,
                        height: MediaQuery.of(context).size.height * 0.085,
                        child: SingleChildScrollView(
                          child: Text(
                            dis,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
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
