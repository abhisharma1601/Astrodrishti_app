import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:astrodrishti_app/brain/wids.dart';
import 'package:flutter/material.dart';

List coordinates = [];

Future picloc(context) async {
  List<Widget> locs = [];
  TextEditingController loc = TextEditingController();

  Future<void> fetchlocs() async {
    locs = [];
    http.Response res = await http.get(Uri.parse(
        "https://us1.locationiq.com/v1/search.php?key=pk.40f17642118bbc50df447bcca8130c31&q=${loc.text.toString()}&format=json"));
    print(jsonDecode(res.body).runtimeType);
    for (var i in jsonDecode(res.body)) {
      locs.add(LocBox(
        lat: i["lat"],
        lon: i["lon"],
        name: i["display_name"],
      ));
    }
  }

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, setState) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.amberAccent.shade700),
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(child: Txtfld(txt: "Location", contro: loc)),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            await fetchlocs();
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.amberAccent[700],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Icon(
                              Icons.search,
                              size: 38,
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.55,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: locs,
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
  return coordinates;
}

class LocBox extends StatelessWidget {
  LocBox({
    required this.lat,
    required this.lon,
    required this.name,
  });
  String lat, lon, name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        coordinates = [];
        coordinates.add(lat);
        coordinates.add(lon);
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.amberAccent.shade700),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: Text(
          name,
          style: TextStyle(color: Colors.white, fontSize: 16),
        )),
      ),
    );
  }
}
