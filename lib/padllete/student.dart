import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:studyivs/StudentOnly/Assignment.dart';
import 'package:studyivs/StudentOnly/Attendance.dart';
import 'package:studyivs/StudentOnly/scheduled_class.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studyivs/StudentOnly/Post.dart';

bool _one = false;
bool _two = false;
bool _three = false;
bool _four = false;
class StudentPadellete extends StatefulWidget {
  String mailId,subName,teacherid;
  StudentPadellete({this.mailId,this.subName,this.teacherid});
  @override
  _StudentPadelleteState createState() => _StudentPadelleteState(mailId,subName,teacherid);
}

class _StudentPadelleteState extends State<StudentPadellete> {
  String mailId,subName,teacherid;
  _StudentPadelleteState(this.mailId,this.subName,this.teacherid);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    print("In paddelete $mailId");
    print("In paddelete $subName");
    return Scaffold(
        appBar: AppBar(
          title: Text('Vote'),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
        ),

      body:(ShowStudentPadellete(mailId,subName,teacherid)),
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
          child: Icon(Icons.assignment),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue[900],
          label: 'Assignment',
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Assignment(subName: subName,userEmailId: mailId,teacherid: teacherid)));
          },
          closeSpeedDialOnPressed: false,
        ),
        SpeedDialChild(
          child: Icon(Icons.person),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue[900],
          label: 'Attendance',
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Attendance(subName: subName,mailId: mailId,teacherid: teacherid,)));
          },
          closeSpeedDialOnPressed: false,
        ),
        SpeedDialChild(
          child: Icon(Icons.question_answer),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue[900],
          label: 'Post',
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Posts(mailId: mailId,subName: subName,teacherid: teacherid)));
          },
        ),
        //  Your other SpeeDialChildren go here.
      ],
    ),
      );
  }
}

class ShowStudentPadellete extends StatefulWidget {
  String mailId,subName,teacherid;
  ShowStudentPadellete(this.mailId,this.subName,this.teacherid);

  @override
  _ShowStudentPadelleteState createState() => _ShowStudentPadelleteState(mailId,subName,teacherid);
}

class _ShowStudentPadelleteState extends State<ShowStudentPadellete> {
  bool _selected=false;
  String mailId,subName,teacherid;
_ShowStudentPadelleteState(this.mailId,this.subName,this.teacherid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection(teacherid).document(subName ).collection("Padellete").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: new CircularProgressIndicator());
          return Container(
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.only(bottom: 15.0),
            child: new ListView(
              // ignore: deprecated_member_use
              children: snapshot.data.documents.map((document) {
                var getquestion = document['Question'];
                var getoption1 = document['option1'];
                var getoption2 = document['option2'];
                var getoption3 = document['option3'];
                var getoption4 = document['option4'];
                String voteone=document['vote1'];
                String votetwo=document['vote2'];
                String votethree=document['vote3'];
                String votefour=document['vote4'];
                print("this is .........get question $getquestion");
                return Card(
                  elevation: 10,
                  shadowColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                      height: MediaQuery.of(context).size.height*0.95,
                      color: Colors.white70,
                      padding: EdgeInsets.only(top: 30,bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Text("Qn  $getquestion", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                          SizedBox(height: 30.0,),
                          Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 22),
                                          width: MediaQuery.of(context).size.width*0.8,
                                          child: RaisedButton(onPressed: (){

                                            if(_selected!=true){
                                              int voteforone = int.parse(voteone);
                                              voteforone = voteforone+1;
                                              var updatevote = voteforone.toString();
                                              Firestore.instance.collection(teacherid).document(subName).collection("Padellete").document("Padellete")
                                                  .update({
                                                'vote1':updatevote
                                              }).then((onValue) {
                                                print('Created it in sub collection');
                                                setState(() {
                                                  _selected=true;
                                                  _one = true;
                                                });

                                              }).catchError((e) {
                                                print(e);
                                              });
                                            }else{
                                              print('You have votted already');
                                              Fluttertoast.showToast(
                                                  msg: "You have votted already",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  textColor: Colors.white,
                                                  backgroundColor: Colors.black
                                              );
                                            }

                                          }, child: Text("$getoption1",style: TextStyle(color: Colors.white),),
                                            color: _one ? Colors.green: Colors.blue[900],
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                            ),
                                          ),
                                        )
                                      ]
                                  ),
                                ),
                                Container(
                                  child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 22),
                                          width: MediaQuery.of(context).size.width*0.8,
                                          child: RaisedButton(onPressed: (){
                                            if(_selected!=true){
                                              int votefortwo = int.parse(votetwo);
                                              votefortwo = votefortwo+1;
                                              var updatevote = votefortwo.toString();
                                              Firestore.instance.collection(teacherid).document(subName).collection("Padellete").document("Padellete")
                                                  .update({
                                                'vote2':updatevote
                                              }).then((onValue) {
                                                print('Created it in sub collection');
                                                setState(() {
                                                  _selected=true;
                                                });

                                              }).catchError((e) {
                                                print(e);
                                                Fluttertoast.showToast(
                                                    msg: "You have votted already",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    textColor: Colors.white,
                                                    backgroundColor: Colors.black
                                                );
                                              });
                                            }
                                          }, child: Text("$getoption2",style: TextStyle(color: Colors.white),),
                                            color: _one ? Colors.blue[900]: Colors.green,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                            ),
                                          ),
                                        )
                                      ]
                                  ),
                                ),
                                Container(
                                  child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 22),
                                          width: MediaQuery.of(context).size.width*0.8,
                                          child: RaisedButton(onPressed: (){
                                            if(_selected!=true){
                                              int voteforthree = int.parse(votethree);
                                              voteforthree = voteforthree+1;
                                              var updatevote = voteforthree.toString();
                                              Firestore.instance.collection(teacherid).document(subName).collection("Padellete").document("Padellete")
                                                  .update({
                                                'vote3':updatevote
                                              }).then((onValue) {
                                                print('Created it in sub collection');
                                                setState(() {
                                                  _selected=true;
                                                });

                                              }).catchError((e) {
                                                print(e);
                                                Fluttertoast.showToast(
                                                    msg: "You have votted already",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    textColor: Colors.white,
                                                    backgroundColor: Colors.black
                                                );
                                              });
                                            }
                                            }, child: Text("$getoption3",style: TextStyle(color: Colors.white),),
                                            color: Colors.blue[900],
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                            ),
                                          ),
                                        )
                                      ]
                                  ),
                                ),
                                Container(
                                  child: Row(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 22),
                                          width: MediaQuery.of(context).size.width*0.8,
                                          child: RaisedButton(onPressed: (){
                                            if(_selected!=true){
                                              int voteforone = int.parse(votefour);
                                              voteforone = voteforone+1;
                                              var updatevote = voteforone.toString();
                                              Firestore.instance.collection(teacherid).document(subName).collection("Padellete").document("Padellete")
                                                  .update({
                                                'vote4':updatevote
                                              }).then((onValue) {
                                                print('Created it in sub collection');
                                                setState(() {
                                                  _selected=true;
                                                });

                                              }).catchError((e) {
                                                print(e);
                                                Fluttertoast.showToast(
                                                    msg: "You have votted already",
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    textColor: Colors.white,
                                                    backgroundColor: Colors.black
                                                );
                                              });
                                            }
                                            }, child: Text("$getoption4",style: TextStyle(color: Colors.white),),
                                            color: Colors.blue[900],
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                            ),
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                              ]
                          )
                        ],
                      )
                  ),
                );
              }).toList(),
            ),
          );
        }
    );
  }
}
