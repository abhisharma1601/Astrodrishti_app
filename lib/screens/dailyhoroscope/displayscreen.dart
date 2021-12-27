import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HoroscopeDisplay extends StatefulWidget {
  HoroscopeDisplay(
      {required this.dailyData, required this.weeklyData, required this.name});
  String dailyData = "Loading...";
  String weeklyData = "Loading...";
  String name = "";

  @override
  _HoroscopeDisplayState createState() => _HoroscopeDisplayState();
}

class _HoroscopeDisplayState extends State<HoroscopeDisplay> {
  @override
  late Color _daily_color;
  late Color _weekely_color;
  String _dis_text = "";

  void initState() {
    _daily_color = Color(0xffD2ccc4).withOpacity(0.8);
    _weekely_color = Color(0xffD2ccc4);
    _dis_text = widget.dailyData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff1f8ac0).withOpacity(0.2),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 325,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(60)),
                  image: DecorationImage(
                      image: AssetImage("images/gradient_horo.jpg"),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_rounded)),
                    Center(
                      child: Image(
                          height: 200,
                          width: 200,
                          image: AssetImage("images/signs/${widget.name}.png")),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _dis_text = widget.dailyData;
                        _daily_color = Color(0xffD2ccc4).withOpacity(0.8);
                        _weekely_color = Color(0xffD2ccc4);
                      });
                    },
                    child: Chip(
                      side: BorderSide(color: Colors.black),
                      label: Text(
                        "Daily Horoscope",
                        style: TextStyle(color: Colors.black),
                      ),
                      backgroundColor: _daily_color,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _dis_text = widget.weeklyData;
                        _daily_color = Color(0xffD2ccc4);
                        _weekely_color = Color(0xffD2ccc4).withOpacity(0.8);
                      });
                    },
                    child: Chip(
                      side: BorderSide(color: Colors.black),
                      label: Text(
                        "Weekly Horoscope",
                        style: TextStyle(color: Colors.black),
                      ),
                      backgroundColor: _weekely_color,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .008,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  _dis_text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
