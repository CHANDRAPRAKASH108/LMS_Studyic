import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ClassJoinView extends StatelessWidget {
  String classUrl="https://us04web.zoom.us/j/5428204101?pwd=dHpPYi9STFc3Z1BaQWpzQ1EyMTNhdz09";
  ClassJoinView(this.classUrl);
  Future<void> _launched;
  String _launchUrl ="https://zoom.us";

  Future<Void> _launchInBrowser(String url)async{
   if(await canLaunch(url)){
     await launch(url,forceSafariVC: false,forceWebView: false,headers: <String ,String>{'header_key':'header_value'},);
   }else{
     print("Couldnot launch url");
   }
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    print(classUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text('Joining Teacher.Class'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: Center(
        child: (Container(
          padding: EdgeInsets.only(top: 150.0),
          width: MediaQuery.of(context).size.width*0.8,
          child: Column(
            children: <Widget>[
              new Text("Click on join the class button to attend the class", style: TextStyle(color: Colors.blue[900],fontSize: 20.0,fontWeight: FontWeight.bold),),
              SizedBox(height: 50.0,),
              new RaisedButton(onPressed: (){
                _launchInBrowser(classUrl);
              },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)
                ),
                color: Colors.blue[900],
              child: Text('Join the Teacher.Class',style: TextStyle(color: Colors.white),),
              )
            ],
          ),
        )),
      ),
    );
  }
}



