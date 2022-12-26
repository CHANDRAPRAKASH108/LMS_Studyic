import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studyivs/Teacher/Class/PDFViewer.dart';

String uploadpdfteacher="";
String teacherid;
String subjectname;
String title;
String actualemail;

class SubmittedAssignment extends StatefulWidget {
  String value;
  String sssubjectname;
  String ssteacherid,id;
  SubmittedAssignment({this.value,this.sssubjectname,this.ssteacherid,this.id});
  @override
  _SubmittedAssignmentState createState() => _SubmittedAssignmentState(value,sssubjectname,ssteacherid,id);
}

class _SubmittedAssignmentState extends State<SubmittedAssignment> {
  String value;
  String sssubjectname;
  String ssteacherid,id;

_SubmittedAssignmentState(this.value,this.sssubjectname,this.ssteacherid,this.id);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    setState(() {
      title=value.toString();
      teacherid= ssteacherid.toString();
      subjectname=sssubjectname.toString();
    });
    return Scaffold(appBar: AppBar(
      title: Text('Submissions'),
      centerTitle: true,
      backgroundColor: Colors.pinkAccent[200],
    ),
      body: (
      CheckAssignment(context)
      ),
    );
  }
}

CheckAssignment(BuildContext context) {
  final usersRef = Firestore.instance.collection(teacherid)
      .document(subjectname)
      .collection(teacherid);
  usersRef.getDocuments().then((QuerySnapshot snapshot) {
    // ignore: deprecated_member_use
    snapshot.documents.forEach((DocumentSnapshot doc) async {
      var studentlinkemail = doc.id;

      Firestore.instance.collection(studentlinkemail).document(subjectname).collection("upload").document(title).get()
      .then((DocumentSnapshot snapshot){
        if(snapshot.exists){
          String pdflink = snapshot['Uploaded link'];
          print("uploaded link $pdflink");
          print(studentlinkemail);
          return new ListView(
            children: <Widget>[
              new Card(
                child: Container(
                  height: 170,
                  child: new Row(
                    children: <Widget>[
                      new Text(studentlinkemail,style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                      Container(
                        width: MediaQuery.of(context).size.width*0.7,
                        margin: EdgeInsets.only(left: 10),
                        child: new RaisedButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => new ShowPdf(value: pdflink,)));
                        },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 10,
                          color: Colors.blue[900],
                          child: Text("See Submission", style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width*0.7,
                        margin: EdgeInsets.only(left: 10),
                        child: new RaisedButton(onPressed: (){
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => new ShowPdf(value: pdflink,)));
                        },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 10,
                          color: Colors.blue[900],
                          child: Text("Assign Score", style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }else{

        }
      });
    });
  });
}
