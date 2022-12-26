import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:studyivs/StudentOnly/Assignment.dart';
import 'package:studyivs/StudentOnly/Attendance.dart';
import 'package:studyivs/StudentOnly/Post.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyivs/UI/subjecttile.dart';
import 'package:studyivs/padllete/student.dart';

import 'scheduled_class.dart';

var userEmailId;
String regd;
String url = "www.google.co.in";
DateTime dateTimeNow = DateTime.now();
bool _fetched = false;
String paymentUrl =
    "https://www.eduqfix.com/PayDirect/#/student/pay/t+znLqq9NN80kSDUbCcHUO0LBiDHTDPPrm8mNpJ2Q20G4MMoUQeHOednJZ6B7lAy/354";
class ClassOverview extends StatefulWidget {
  @override
  _ClassOverviewState createState() => _ClassOverviewState();
}

class _ClassOverviewState extends State<ClassOverview> {
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetail();
  }

  @override
  getdetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      regd = prefs.getString("regd_no");
      _fetched = true;
    });
  }
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Classroom',style: TextStyle(color: Colors.blue[900]),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _fetched ?SafeArea(child: CategoriesScroller()):null
    );
  }
}

class CategoriesScroller extends StatefulWidget {
  @override
  _CategoriesScrollerState createState() => _CategoriesScrollerState();
}

class _CategoriesScrollerState extends State<CategoriesScroller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(regd)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return new Center(child: CircularProgressIndicator());
            return _fetched ?  Container(
              decoration: BoxDecoration(
                //color: Colors.grey[200],
              ),
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              //margin: EdgeInsets.only(bottom: 15.0),
              child: new ListView(
                children: snapshot.data.docs.map((document) {
                  var subName = document.id;
                  var teacherid = document['Teacher Id'];
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet<void>(
                        isScrollControlled: true,
                        backgroundColor: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(45.0),
                              topRight: const Radius.circular(45.0)
                          ),
                        ),
                        context: context,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Container(
                              height: 300,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ListTile(
                                      leading: new Icon(Icons.calendar_today,color: Colors.white,),
                                      title: new Text('Scheduled Classes',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.038),),
                                      onTap: () {
                                        //Navigator.pop(context);
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ScheduledClass(subname: subName,mailId: regd,teacherid: teacherid)));
                                      },
                                    ),
                                    ListTile(
                                      leading: new Icon(Icons.assignment,color: Colors.white,),
                                      title: new Text('Assignment',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.038),),
                                      onTap: () {
                                        //Navigator.pop(context);
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Assignment(subName: subName,userEmailId: regd,teacherid: teacherid)));
                                      },
                                    ),
                                    ListTile(
                                      leading: new Icon(Icons.question_answer,color: Colors.white,),
                                      title: new Text('Vote',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.038),),
                                      onTap: () {
                                        //Navigator.pop(context);
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> StudentPadellete(mailId: regd,subName: subName,teacherid: teacherid)));
                                      },
                                    ),
                                    ListTile(
                                      leading: new Icon(Icons.people,color: Colors.white,),
                                      title: new Text('Attendance',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.038),),
                                      onTap: () {
                                        //Navigator.pop(context);
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Attendance(subName: subName,mailId: regd,teacherid: teacherid)));
                                      },
                                    ),
                                    ListTile(
                                      leading: new Icon(Icons.assignment,color: Colors.white,),
                                      title: new Text('Post',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.038),),
                                      onTap: () {
                                        //Navigator.pop(context);
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Posts(mailId: regd,subName: subName,teacherid: teacherid)));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: SubjectTile(subName)
                  );
                }).toList(),
              ),
            ):Center(child: CircularProgressIndicator());
          }
          ),
    );
  }
}
