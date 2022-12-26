import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:studyivs/StudentOnly/Attendance.dart';
import 'package:studyivs/Teacher/Class/Assignmentlist.dart';
class StudentList extends StatefulWidget {
  String subjectname,teacherid;
  StudentList({required this.subjectname,required this.teacherid});
  @override
  _StudentListState createState() => _StudentListState(subjectname,teacherid);
}

class _StudentListState extends State<StudentList> {
  String subjectname,teacherid;
  _StudentListState(this.subjectname,this.teacherid);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Student"),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (ShowStudent(subjectname,teacherid)),
    );
  }
}

class ShowStudent extends StatefulWidget {
  @override
  String subjectname,teacherid;
  ShowStudent(this.subjectname,this.teacherid);
  _ShowStudentState createState() => _ShowStudentState(subjectname,teacherid);
}

class _ShowStudentState extends State<ShowStudent> {
  String subjectname,teacherid;
  _ShowStudentState(this.subjectname,this.teacherid);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection(teacherid).document(subjectname).collection(teacherid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.only(bottom: 15.0),
            child: ListView(
              // ignore: deprecated_member_use
              children: snapshot.data!.documents.map((document){
                String studentemail = document.id;
                return new  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(width: 2,color: Colors.lightBlueAccent)
                    ),
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                      },
                      child: Container(
                        height: 170,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 35, left: 30),
                                child: new Column(
                                  children: <Widget>[
                                    new Text(studentemail, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.035, fontWeight: FontWeight.bold),overflow: TextOverflow.fade,),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.7,
                                      margin: EdgeInsets.only(left: 10),
                                      child: new RaisedButton(onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => new Attendance(subName: subjectname,mailId: studentemail,teacherid: teacherid,)));
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => new ShowPdf(value: pdflink,)));
                                      },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        elevation: 10,
                                        color: Colors.blue[900],
                                        child: Text("Attendance", style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.7,
                                      margin: EdgeInsets.only(left: 10),
                                      child: new RaisedButton(onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => new AssignmentList(mailId: studentemail, subname: subjectname)));
                                      },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        elevation: 10,
                                        color: Colors.blue[900],
                                        child: Text("Assignment", style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        ),
                      ),
                    )
                );
              }).toList(),
            ),
          );
        }
    );
  }
}

