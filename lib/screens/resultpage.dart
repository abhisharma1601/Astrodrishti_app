import 'package:astrodrishti_app/brain/payment.dart';
import 'package:astrodrishti_app/brain/wids.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../startpage.dart';

class result_page extends StatefulWidget {
  result_page({
    required this.pp,
    required this.lat,
    required this.lon,
    required this.perso,
    required this.name,
    required this.dob,
    required this.bp,
    required this.bt,
    required this.sun,
    required this.moon,
    required this.areport,
    required this.mercury,
    required this.mars,
    required this.saturn,
    required this.venus,
    required this.lagan,
    required this.jupiter,
  });
  String pp;
  String perso,
      sun,
      moon,
      mars,
      mercury,
      jupiter,
      saturn,
      venus,
      areport,
      lagan;
  String lat, lon;
  String name, dob, bp, bt;

  @override
  _result_pageState createState() => _result_pageState();
}

class _result_pageState extends State<result_page> {
  @override
  bool spin = false;
  late Razorpay _razorpay;
  String em = null as String;

  _launchURL() async {
    const url = 'https://astrodrishti.online/demokundli.pdf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: GestureDetector(
        onTap: () {
          setState(() {
            spin = true;
          });
          em = currentuser.passemail();

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => py_pg(
                        type: "Report",
                        pricee: reportprice,
                        lat: widget.lat,
                        lon: widget.lon,
                        name: widget.name,
                        dob: widget.dob,
                        bp: widget.bp,
                        bt: widget.bt,
                        que: "No Question Only Report !",
                      )));
          setState(() {
            spin = false;
          });
        },
        child: CircleAvatar(
          backgroundColor: Colors.amberAccent[700],
          radius: 35.5,
          child: CircleAvatar(
            radius: 34,
            child: Column(
              children: [
                SizedBox(
                  height: 7,
                ),
                Image.asset(
                  "images/rp.jpg",
                  height: 35,
                  width: 35,
                ),
                Text(
                  "Full Report".tr(),
                  style: TextStyle(
                      color: Colors.amberAccent[700],
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.amberAccent[700],
        title: Text(
          "Birth Report 卐".tr(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Pre_box(
              head: "Planet Positioning:".tr(),
              body: widget.pp,
            ),
            Pre_box(
              head: "Personality".tr(),
              body: widget.perso,
            ),
            Pre_box(
              head: "Ascendant Report".tr(),
              body: widget.areport,
            ),
            Pre_box(
              head: "Your Sun".tr(),
              body: widget.sun,
            ),
            Pre_box(
              head: "Your Moon".tr(),
              body: widget.moon,
            ),
            Pre_box(
              head: "Your Mercury".tr(),
              body: widget.mercury,
            ),
            Pre_box(
              head: "Your Jupiter".tr(),
              body: widget.jupiter,
            ),
            Pre_box(
              head: "Your Mars".tr(),
              body: widget.mars,
            ),
            Pre_box(
              head: "Your Venus".tr(),
              body: widget.venus,
            ),
            Pre_box(
              head: "Your Saturn".tr(),
              body: widget.saturn,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[],
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _razorpay = Razorpay();
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  //   _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //   _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _razorpay.clear();
  // }

  // void openCheckout() async {
  //   var options = {
  //     'key': 'rzp_live_gHP6X7vwBedVA2',
  //     'amount': price * 100,
  //     'name': 'AstroDrishti',
  //     'description': 'Pdf Package',
  //     'prefill': {'contact': 'Enter Mobile', 'email': '$em'},
  //   };

  //   try {
  //     _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint(e);
  //   }
  // }

  // _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   final snapShot = await FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc("Orders")
  //       .collection(em)
  //       .doc("000000AAAAA")
  //       .get();
  //   if (snapShot.exists) {
  //   } else {
  //     await FirebaseFirestore.instance
  //         .collection("Users")
  //         .doc("Orders")
  //         .collection(em)
  //         .doc("000000AAAAA")
  //         .set({"count": 1});
  //   }
  //   var orderidsp = await FirebaseFirestore.instance
  //       .collection("AppData")
  //       .doc("ordernumber")
  //       .get();
  //   var orderid = orderidsp.data()["number"];
  //   await FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc("Orders")
  //       .collection(em)
  //       .doc("000000AAAAA")
  //       .update({"count": FieldValue.increment(1)});
  //   await FirebaseFirestore.instance
  //       .collection("AppData")
  //       .doc("ordernumber")
  //       .update({"number": FieldValue.increment(1)});
  //   await FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc("Orders")
  //       .collection(em)
  //       .doc("$orderid")
  //       .set({
  //     "Name": widget.name,
  //     "DOB": widget.dob,
  //     "Birthtime": widget.bt,
  //     "birthstate": widget.bp,
  //     "Lat": widget.lat,
  //     "Lon": widget.lon,
  //     "Order ID": orderid,
  //     "Type": "Report",
  //     "url": "https://astrodrishti1601.github.io/thankyoupage/"
  //   }).then(
  //     (value) => Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => finalpage(
  //           head: "Thank You",
  //           pyt: "Payment Successfull !",
  //           body:
  //               "Details for the current kundli will be saved in our Databse for PDF analysis which can take upto 1 day beacuse it is done by astrologer manually for best results. Kundli PDF will be provided On the email through which you have logged in, in the app. Note down Payment ID for any help in future. Order Status Can be seen in current orders.",
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => finalpage(
  //         head: "Incomplete !",
  //         pyt: "Payment Failed !",
  //         body:
  //             "Payment Failed due to some reasons. Please try with valid details or try after some time. Thank You",
  //       ),
  //     ),
  //   );
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => finalpage(
  //         head: "Sorry !",
  //         pyt: "Payment Failed !",
  //         body:
  //             "Payment Failed as we currrently do not accept payments with wallets. Try using UPI or Card. Thank You",
  //       ),
  //     ),
  //   );
  // }
}
