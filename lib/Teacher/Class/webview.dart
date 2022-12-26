import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
String attendanceCounter;
class WebView extends StatefulWidget {
  String classlink,mailId,title,subname;
  bool hasAttended;
  WebView({this.classlink,this.mailId,this.title,this.subname,this.hasAttended});
  @override
  _WebViewState createState() => _WebViewState(classlink,mailId,title,subname,hasAttended);
}

class _WebViewState extends State<WebView> {
  String classlink,mailId,title,subname;
  bool hasAttended;
  _WebViewState(this.classlink,this.mailId,this.title,this.subname,this.hasAttended);
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Are you sure want to quit ?'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),

          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () { 
              SystemNavigator.pop();
            },
            child: Text("YES"),

          ),
        ],
      ),
    ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Live Teacher.Class'),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
        ),
        body: (
            Container(
                child: Column(children: <Widget>[
                  Expanded(
                      child: InAppWebView(
                        initialUrl: classlink,
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
                            String url) async {
                          AttendanceCounter(mailIdUser: mailId,title: title,hasAttended: hasAttended,subname: subname);
                        },
                      )),

                ])
            )
        ),
      ),
    );
  }
}

Future<String> AttendanceCounter(
    {String mailIdUser, String subname, bool hasAttended, String title}) async {
  if (hasAttended = false) {
    FirebaseFirestore.instance
        .collection(mailIdUser.toString())
        .doc(subname.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print(
            "..................xwsddd.........wsds......${documentSnapshot["Attendance Counter"]}");
        attendanceCounter = documentSnapshot.data()["Attendance Counter"];
        int counterInt = int.parse(attendanceCounter) + 1;
        FirebaseFirestore.instance
            .collection(mailIdUser.toString())
            .doc(subname.toString())
            .update({'Attendance Counter': counterInt.toString()});
        FirebaseFirestore.instance
            .collection(mailIdUser)
            .doc(subname)
            .collection("classes")
            .doc(title)
            .update({"hasAttended": true});
      }
    });
  } else {}
}
