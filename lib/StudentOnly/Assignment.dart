import 'package:flutter/services.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:studyivs/StudentOnly/Assignment_pdf_viewer.dart';
import 'package:studyivs/StudentOnly/Attendance.dart';
import 'package:studyivs/StudentOnly/Post.dart';
import 'package:studyivs/StudentOnly/scheduled_class.dart';
import 'package:playstore/StudentOnly/showsubmission.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:playstore/StudentOnly/widget/uploadassignmentstudent.dart';
import 'package:playstore/padllete/student.dart';

String subjectName;
DateTime myDateTime;
Timestamp timeStamp;
String uploadurl, score;
String url;
String mailId;
List<String> selectedfile;
var _object;
var uploadPdfUrl;
ProgressDialog pd;
String assignmentTitle;
String link;

bool _assignmentupload = false;

class Assignment extends StatefulWidget {
  final String subName;
  final String userEmailId,teacherid;
  Assignment({this.subName, this.userEmailId,this.teacherid});

  @override
  _AssignmentState createState() => _AssignmentState(subName, userEmailId,teacherid);
}

class _AssignmentState extends State<Assignment> {
  String subName;
  String userEmailId,teacherid;
  _AssignmentState(this.subName, this.userEmailId,this.teacherid);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    setState(() {
      subjectName = subName.toString();
      mailId = userEmailId.toString();
    });
    print("This is assignment subject $subjectName");
    print("This is assignment mailId $mailId");
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments'),
        backgroundColor: Colors.blue[900],
        centerTitle: true,
      ),
      body: (ShowAssignment(subName, mailId,teacherid)),
          floatingActionButton: SpeedDial(
          child: Icon(Icons.subject),
      closedForegroundColor: Colors.white,
      openForegroundColor: Colors.white,
      closedBackgroundColor: Colors.blue[900],
      openBackgroundColor: Colors.blue[900],
      speedDialChildren: <SpeedDialChild>[
        SpeedDialChild(
          child: Icon(Icons.calendar_today),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue[900],
          label: 'Scheduled Classes',
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ScheduledClass(subname: subName,mailId: mailId,teacherid: teacherid)));
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.person),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue[900],
          label: 'Attendance',
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Attendance(subName: subName,mailId: mailId,teacherid: teacherid)));
          },
          closeSpeedDialOnPressed: false,
        ),
        SpeedDialChild(
          child: Icon(Icons.assignment),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue[900],
          label: 'Post',
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Posts(mailId: mailId,subName: subName,teacherid: teacherid)));
          },
          closeSpeedDialOnPressed: false,
        ),
        SpeedDialChild(
          child: Icon(Icons.question_answer),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue[900],
          label: 'Vote',
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> StudentPadellete(mailId: mailId,subName: subName,teacherid: teacherid)));
          },
        ),
        //  Your other SpeeDialChildren go here.
      ],
    ),
    );
  }
}

class ShowAssignment extends StatefulWidget {
  String subName;
  String mailId,teacherid;
  ShowAssignment(this.subName, this.mailId,this.teacherid);
  @override
  _ShowAssignmentState createState() => _ShowAssignmentState(subName,mailId,teacherid);
}

class _ShowAssignmentState extends State<ShowAssignment> {
  String subName,mailId,teacherid;
  _ShowAssignmentState(this.subName,this.mailId,this.teacherid);
  bool isAllowedDeadline() {
    myDateTime = timeStamp.toDate();
    DateTime now = DateTime.now();
    if (now.isBefore(myDateTime)) {
      return true;
    } else {
      return false;
    }
  }
  getlink(String mailId, String subName, String value)async{
    await Firestore.instance.collection(mailId).document(subName).collection('upload').document(value).get()
        .then((DocumentSnapshot snapshot){
      if(snapshot.exists){
        setState(() {
          url = snapshot['Uploaded link'];
          print("this is uploaded url $url");
        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ShowSubmission(url: url)));
      }else{
        Fluttertoast.showToast(
            msg: "No Submission Found",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            backgroundColor: Colors.black);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection(teacherid)
            .doc(subName)
            .collection("Assignment")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: new CircularProgressIndicator());
          return Container(
            padding: EdgeInsets.all(10.0),
            child: new ListView(
              // ignore: deprecated_member_use
              children: snapshot.data.documents.map((document) {
                //print(document['Assignment title']);
                var value = document['Assignment_title'];
                var sub = document['''Assignment_Subtitle'''];
                String AssignmentLink = document['Assignment_Link'];
                String deadline = document['Assignment_Deadline'];
                timeStamp = document['Timestamp'];
                String deadlineTime = document['Assignment_Time'];

                return new Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  //height: MediaQuery.of(context).size.height*0.3,
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.blue[900]),
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: Container(
                    //padding: EdgeInsets.only(left: 10),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Text("Topic :",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: MediaQuery.of(context).size.width*0.04
                                )),
                            Text(
                              value.toString(),
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width*0.04, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Sub-Title :",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: MediaQuery.of(context).size.width*0.04
                              ),
                            ),
                            Text(
                              sub.toString(),
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width*0.04
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text("Submission Deadline:",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: MediaQuery.of(context).size.width*0.04
                                )),
                            Text(deadline + " " + deadlineTime,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width*0.04
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),

                        //new Text(classlink, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              //margin: EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => ShowPdf(
                                            value: AssignmentLink,
                                            title: "Assignment",
                                          ),
                                        ),
                                      );
                                    },
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    color: Colors.blue[900],
                                    child: Text(
                                      "See Assignment",
                                      style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),
                                    ),
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width/20,),
                                  isAllowedDeadline()
                                      ? new RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        assignmentTitle = value;
                                      });
                                      //AssignmentDialog(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> UploadAssignmentStudent(deadlineTime: deadlineTime,deadline: deadline,value: value,subjectName: subjectName,userEmailId: mailId)));
                                    },
                                    elevation: 10,
                                    color: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0)
                                    ),
                                    child: Text(
                                      "Submit",
                                      style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),
                                    ),
                                  )
                                      : RaisedButton(onPressed: (){},
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0)
                                    ),
                                    color: Colors.grey,
                                    child: Text('Submit',style: TextStyle(color: Colors.white),),
                                  ),
                                ],
                              ),
                          ),
                        ),
                        RaisedButton(
                          onPressed: ()async{
                            print("this is value for assignment $value");
                            getlink(mailId,subName,value);
                            //Navigator.push(context, MaterialPageRoute(builder: (context)=> ShowSubmission(mailId: mailId,subName: subName,assignmentTitle: value)));
                          },
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.blue[900])
                          ),
                          color: Colors.white,
                          child: Text(
                            "View Submission",
                            style: TextStyle(color: Colors.blue[900],fontSize: MediaQuery.of(context).size.width*0.04),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

          );
        });
  }
}
