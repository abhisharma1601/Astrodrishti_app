import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:math';

import '../startpage.dart';
import 'paymentint.dart';
import 'wids.dart';

class py_pg extends StatefulWidget {
  py_pg(
      {required this.pricee,
      required this.type,
      required this.lat,
      required this.que,
      required this.lon,
      required this.name,
      required this.dob,
      required this.bt,
      required this.bp});
  String type, lat, lon, name, dob, bp, bt, que;
  int pricee;

  @override
  _py_pgState createState() => _py_pgState();
}

class _py_pgState extends State<py_pg> {
  @override
  void initState() {
    prc = widget.pricee;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    oC();
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    var orderid = await Random().nextInt(100000000);    
    await FirebaseFirestore.instance
        .collection('Users')
        .doc("Orders")
        .collection(currentuser.passemail())
        .doc("$orderid")
        .set({
      "Name": widget.name,
      "DOB": widget.dob,
      "Birthtime": widget.bt,
      "birthstate": widget.bp,
      "Lat": widget.lat,
      "Lon": widget.lon,
      "Order ID": orderid,
      "Type": widget.type,
      "Question": widget.que,
      "url": "https://astrodrishti1601.github.io/thankyoupage/",
      "Status": false,
      "Pay_id":response.paymentId
    }).then(
      (value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => finalpage(
            head: "Thank You".tr(),
            pyt: "Payment Successfull !".tr(),
            body:
                "Details for the current kundli will be saved in our Databse for PDF analysis which can take upto 1 day beacuse it is done by astrologer manually for best results. Kundli PDF will be provided On the email through which you have logged in, in the app. Note down Payment ID for any help in future. Order Status Can be seen in current orders."
                    .tr(),
          ),
        ),
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => finalpage(
          head: "Incomplete !".tr(),
          pyt: "Payment Failed !".tr(),
          body:
              "Payment Failed due to some reasons. Please try with valid details or try after some time. Thank You"
                  .tr(),
        ),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => finalpage(
          head: "Incomplete !".tr(),
          pyt: "Payment Failed !".tr(),
          body:
              "Payment Failed as we currrently do not accept payments with wallets. Try using UPI or Card. Thank You"
                  .tr(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: true,
      opacity: 0,
      child: Scaffold(
        body: Column(),
      ),
    );
  }
}

Razorpay _razorpay = null as Razorpay;
int prc = null as int;

void oC() async {
  var options = {
    'key': keyrz,
    'amount': prc * 100,
    'name': 'AstroDrishti',
    'description': 'Astrodrishti Payment Gateway',
    'prefill': {'contact': 'Enter Mobile', 'email': currentuser.passemail()},
  };

  try {
    _razorpay.open(options);
  } catch (e) {
    debugPrint(e.toString());
  }
}
