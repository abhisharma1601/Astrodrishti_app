import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class web_vv extends StatefulWidget {
  @override
  _web_vvState createState() => _web_vvState();
}

class _web_vvState extends State<web_vv> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.amberAccent[700],
        title: Text(
          "Blogs".tr(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
          ),
        ),
      ),
      body: WebView(
        initialUrl: 'https://4abhi45.github.io/astrodrishtiapp/blg.html',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
