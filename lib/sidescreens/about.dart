import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class abt_view extends StatefulWidget {
  @override
  _abt_viewState createState() => _abt_viewState();
}

class _abt_viewState extends State<abt_view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent[700],
          title: Text(
            "About App".tr(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
            ),
          ),
        ),
        body: WebView(
          initialUrl:
              'https://4abhi45.github.io/astrodrishtiapp/',
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}
