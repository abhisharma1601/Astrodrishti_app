import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class loading extends StatefulWidget {
  @override
  _loadingState createState() => _loadingState();
}

class _loadingState extends State<loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ModalProgressHUD(
          opacity: 0.0,
          inAsyncCall: true,
          progressIndicator: RefreshProgressIndicator(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
          )),
    );
  }
}
