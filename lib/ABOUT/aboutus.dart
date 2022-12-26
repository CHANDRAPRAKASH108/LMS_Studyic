import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowAbout extends StatefulWidget {
  @override
  _ShowAboutState createState() => _ShowAboutState();
}

class _ShowAboutState extends State<ShowAbout> {
  @override
  Future<void> _launched;

  String _launchurl = "https://studyic.in";

  Future<Void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},
      );
    } else {
      print("Couldnot launch url");
    }
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: (Center(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10.0),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue[900],
                      offset: Offset(5.0, 5.0),
                      blurRadius: 5.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: Image(image: AssetImage("assets/images/studyic.png")),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      'We make your learning experience more easier',
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: RaisedButton(
                    onPressed: () {
                      _launchInBrowser(_launchurl);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    color: Theme.of(context).indicatorColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Visit Our Website',
                          style:
                              TextStyle(color: Theme.of(context).canvasColor),
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white,
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                      'We are working to provide fully digital experience to any educational organisation like online classes , assignments , attendances . If any organisation needs more than what we provide , we will work on that too and make that provided for the organisation.'),
                ),
              ),
              Container(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                    'We do provide web as well as application for android and IoS platforms..we will be in your service by 24*7',
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: Text(
                  'Meet Our Developers',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              CircleAvatar(
                radius: 70.0,
                backgroundImage: AssetImage('assets/images/chandra.jpg'),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                      'Our Android and IoS Developer as well as Web Developer Chandra Prakash Kumar , studying in C.V.Raman Global University Bhubaneshwar in Computer Science Branch'),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              CircleAvatar(
                radius: 70.0,
                backgroundImage: AssetImage('assets/images/akhilesh.jpg'),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                      'Our Web Developer and Android Developer Akhilesh Kumar Jha, studying in C.V.Raman Global University Bhubaneshwar in Computer Science Branch'),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              CircleAvatar(
                radius: 70.0,
                backgroundImage: AssetImage('assets/images/sumit.jpg'),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(
                      'Our UI/ UX Design and Management expert Sumit Kumar , studying in C.V.Raman Global University Bhubaneshwar in Electrical Branch'),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: SizedBox(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "For Any query please mail us on",
                        style:
                            TextStyle(color: Colors.blue[900], fontSize: 16.0),
                      ),
                      Text(
                        "support@studyic.in",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ))),
      ),
    );
  }
}
