import 'package:astrodrishti_app/Store/askquestion.dart';
import 'package:astrodrishti_app/brain/smtp.dart';
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
  py_pg({
    required this.pricee,
    required this.type,
    required this.lat,
    required this.que,
    required this.lon,
    // ignore: non_constant_identifier_names
    required this.astro_id,
    required this.name,
    required this.dob,
    required this.bt,
  });
  String type, lat, lon, name, dob, bt, que;
  // ignore: non_constant_identifier_names
  int pricee, astro_id;

  @override
  _py_pgState createState() => _py_pgState();
}

class _py_pgState extends State<py_pg> {
  @override
  void initState() {
    prc = widget.pricee;
    if (prc == 11) {
      widget.type = "Offer_Question";
    }
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    oC();
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    var orderid = await Random().nextInt(100000000);

    mail(currentuser.passemail(), orderid, widget.type);

    var key = await FirebaseFirestore.instance
        .collection("Astrologers")
        .where('astro_id', isEqualTo: widget.astro_id)
        .get();
    String docval = "";
    for (var i in key.docs) {
      docval = await i.data()["email"];
    }
    print("aide hi");
    print(widget.type);

    if (widget.type == "Question" || widget.type == "Offer_Question") {
      FirebaseFirestore.instance
          .collection("Astrologers")
          .doc(docval)
          .update({"CAPQ": FieldValue.increment(1)});
      notify(docval, orderid, widget.type, widget.astro_id);
    } else if (widget.type == "Report") {
      FirebaseFirestore.instance
          .collection("Astrologers")
          .doc(docval)
          .update({"CAPR": FieldValue.increment(1)});
      notify(docval, orderid, widget.type, widget.astro_id);
    }

    FirebaseFirestore.instance
        .collection("Users")
        .doc("emails")
        .collection(currentuser.passemail())
        .doc("Data")
        .set({"question_1": true}, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(DateTime.now().toString())
        .set({
      "Name": widget.name,
      "DOB": widget.dob,
      "Birthtime": widget.bt,
      "Lat": widget.lat,
      "Lon": widget.lon,
      "OID": orderid,
      "Type": widget.type,
      "Email": currentuser.passemail(),
      "astro_id": astro_id,
      "Question": widget.que,
      "Status": false,
      "reviewed": "show",
      "Pay_id": response.paymentId
    });

    await FirebaseFirestore.instance
        .collection('Users')
        .doc("Orders")
        .collection(currentuser.passemail())
        .doc("$orderid")
        .set({
      "Name": widget.name,
      "DOB": widget.dob,
      "Birthtime": widget.bt,
      "Lat": widget.lat,
      "Lon": widget.lon,
      "Order ID": orderid,
      "Type": widget.type,
      "Question": widget.que,
      "url": "https://astrodrishti1601.github.io/thankyoupage/",
      "Pay_id": response.paymentId
    }).then(
      (value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => finalpage(
            head: "Thank You".tr(),
            pyt: "Payment Successfull !".tr(),
            body:
                "Details for the current kundli will be saved in our Databse for analysis which can take upto 1 day beacuse it is done by astrologer manually for best results. Report/Answer will be uploaded in 1 day and can be seen thorugh my orders section and will be mailed to the registered E-mail. Thank You"
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
