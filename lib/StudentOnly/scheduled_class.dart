import 'dart:ffi';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:studyivs/StudentOnly/Attendance.dart';
import 'package:studyivs/StudentOnly/Post.dart';
import 'package:studyivs/padllete/student.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Assignment.dart';

var subjectid;
Timestamp timeStamp;
DateTime myDateTime;
String mailIdUser;
bool hasAttended = false;
String attendanceCounter;
bool newkey;
int numLecture;
int att;

class ScheduledClass extends StatefulWidget {
  String subname;
  String mailId,teacherid;
  ScheduledClass({this.subname, this.mailId,this.teacherid});

  @override
  _ScheduledClassState createState() => _ScheduledClassState(subname, mailId,teacherid);
}

class _ScheduledClassState extends State<ScheduledClass> {
  final String subname;
  String mailId,teacherid;

  _ScheduledClassState(this.subname, this.mailId,this.teacherid);

  @override
  Widget build(BuildContext context) {
    setState(() {
      mailIdUser = mailId;
    });
    print(subname);
    return Scaffold(
      body: (ShowClasses(subname, mailId,teacherid)),
    );
  }
}

class ShowClasses extends StatefulWidget {
  String subname;
  String mailId,teacherid;
  ShowClasses(this.subname, this.mailId,this.teacherid);

  @override
  _ShowClassesState createState() => _ShowClassesState(subname, mailId,teacherid);
}

class _ShowClassesState extends State<ShowClasses> {
  String subname;
  String mailId,teacherid;

  _ShowClassesState(this.subname, this.mailId,this.teacherid);

  bool isAllowedDeadline() {
    myDateTime = timeStamp.toDate();
    DateTime now = DateTime.now();
    if (now.isAfter(myDateTime) &&
        now.isBefore(myDateTime.add(Duration(hours: 1)))) {
      return true;
    } else {
      return false;
    }
  }
  Future<void> _launched;

  String _launchurl = "https://zoom.us/";

  Future<Void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'},);
    } else {
      print("Couldnot launch url");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getatt();
  }
  getatt()async{
    await FirebaseFirestore.instance
        .collection(mailId)
        .document(subname)
        .collection("classes")
        .get()
        .then((querySnapshot) {
      att = querySnapshot.size;
    });
    FirebaseFirestore.instance.collection(mailId).document(subname).update({
      'Attendance Counter': att,
    });
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text(subname),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(teacherid)
              .document(subname)
              .collection('classes')
          .orderBy("Timestamp",descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: new CircularProgressIndicator(
                  strokeWidth: 10,
                ),
              );
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              padding: EdgeInsets.all(15.0),
              margin: EdgeInsets.only(bottom: 15.0),
              child: new ListView(
                children: snapshot.data.docs.map((document) {
                  var value = document['Class_title'];
                  var sub = document['Class_Subtitle'];
                  var classlink = document['Class_link'];
                  String startDate = document['date'];
                  String startTime = document['time'];
                  timeStamp = document['Timestamp'];
                  return Card(
                    elevation: 10,
                    child: new Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(color: Colors.blue[900])
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 15.0,),
                            Row(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: SizedBox(
                                        width: MediaQuery.of(context).size.width*0.8,
                                        child: Text("Topic: $value",style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.045),))),
                              ],
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width*0.8,),
                            Row(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: SizedBox(
                                        width: MediaQuery.of(context).size.width*0.8,
                                        child: Text("Subtopic: $sub", overflow: TextOverflow.fade,style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.045),))),
                              ],
                            ),
                            SizedBox(height: 15.0,),
                            Row(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text("Date: $startDate",style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.045),)),
                              ],
                            ),
                            SizedBox(height: 15.0,),
                            Row(
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text("Time: $startTime",style: TextStyle(fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.045),)),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () {},
                                    child: isAllowedDeadline() ? Text("Class Ongoing",style: TextStyle(color: Colors.green,fontSize: MediaQuery.of(context).size.width*0.04),):Text("Class Ended",style: TextStyle(color: Colors.red,fontSize: 18.0),)),
                                Container(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: isAllowedDeadline()
                                      ? RaisedButton(
                                    onPressed: () {
                                      AttendanceCounter(
                                        mailid: mailIdUser,
                                        subname: subname,
                                        title: value.toString(),
                                        startdate: startDate,
                                        starttime: startTime,
                                        teacherid: teacherid
                                      );
                                      _launchInBrowser(classlink);
                                    },
                                    elevation: 10,
                                    color: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0)
                                    ),
                                    child: Text(
                                      "Join Now",
                                      style: TextStyle(
                                          color: Colors.white),
                                    ),
                                  )
                                      : RaisedButton(onPressed: (){},
                                    color: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  child: Text('Join Now',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045),),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.subject),
        closedForegroundColor: Colors.white,
        openForegroundColor: Colors.white,
        closedBackgroundColor: Colors.blue[900],
        openBackgroundColor: Colors.blue[900],
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: Icon(Icons.assignment),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Assignment',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Assignment(subName: subname,userEmailId: mailId,teacherid: teacherid)));
            },
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: Icon(Icons.person),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Attendance',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Attendance(subName: subname,mailId: mailId,teacherid: teacherid,)));
            },
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: Icon(Icons.question_answer),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Vote',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> StudentPadellete(mailId: mailId,subName: subname,teacherid: teacherid)));
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.assignment),
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            label: 'Post',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Posts(mailId: mailId,subName: subname,teacherid: teacherid)));
            },
            closeSpeedDialOnPressed: false,
          ),
          //  Your other SpeeDialChildren go here.
        ],
      ),
    );
  }
}
Future<String> AttendanceCounter(
    {String mailid, String subname, String title, String startdate, String starttime,String teacherid}) async {
      FirebaseDatabase.instance.reference().child(teacherid).child(subname).child(mailid).child(startdate+"_"+starttime).set({
        'hasAttended': true
      });
      FirebaseFirestore.instance.collection(mailid).document(subname).collection("classes").document(startdate+"_"+starttime)
      .setData({
        'hasAttended': true,
      });
}
