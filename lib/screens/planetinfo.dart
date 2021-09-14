import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Basicdetails extends StatefulWidget {
  Basicdetails({required this.tablelist});
  List<Widget> tablelist;

  @override
  _BasicdetailsState createState() => _BasicdetailsState();
}

class _BasicdetailsState extends State<Basicdetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: widget.tablelist,
        ),
      ),
    );
  }
}

class New_Tables extends StatelessWidget {
  New_Tables({required this.tablelist, required this.heading});
  List<TableRow> tablelist;
  String heading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            heading,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          SizedBox(
            height: 8,
          ),
          Table(
            textDirection: TextDirection.ltr,
            border:
                TableBorder.all(width: 1.0, color: Colors.amberAccent.shade700),
            children: tablelist,
          ),
        ],
      ),
    );
  }
}

class table_text extends StatelessWidget {
  table_text({required this.text});
  String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textScaleFactor: 1.5,
        style: TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}
