import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewResult extends StatefulWidget {
  String Link;
  WebViewResult({this.Link});
  @override
  _WebViewResultState createState() => _WebViewResultState(Link);
}

class _WebViewResultState extends State<WebViewResult> {
  String Link;
  _WebViewResultState(this.Link);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        title: Text('Result'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (ShowPage(Link)),
    );
  }
}

class ShowPage extends StatelessWidget{
  String Link;
  ShowPage(this.Link);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
        child: Column(children: <Widget>[
          Expanded(
              child: InAppWebView(
                initialUrl: Link,
                //"http://136.232.6.238:8080/CVRCEResult/",
                initialHeaders: {},
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                      debuggingEnabled: true,
                      preferredContentMode: UserPreferredContentMode.DESKTOP),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  //webView = controller;
                },
                onLoadStart: (InAppWebViewController controller, String url) {
                  Center(
                    child: CircularProgressIndicator(),
                  );
                },
                onLoadStop: (InAppWebViewController controller,
                    String url) async {},
              )),

        ])
    );
  }
}
