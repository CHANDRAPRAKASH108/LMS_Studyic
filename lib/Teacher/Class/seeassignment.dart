import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studyivs/Teacher/Class/PDFViewer.dart';

var sssubjectname;
var ssteacherid;
var sslink;

class SeeAssignments extends StatefulWidget {
  var subjectname;
  var teacherid;

  SeeAssignments({this.subjectname,this.teacherid});
  @override
  _SeeAssignmentsState createState() => _SeeAssignmentsState(subjectname,teacherid);
}

class _SeeAssignmentsState extends State<SeeAssignments> {
  var subjectname;
  var teacherid;

  _SeeAssignmentsState(this.subjectname, this.teacherid);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    FirebaseFirebaseFirestore.instance
        .collection(teacherid.toString())
        .document(subjectname.toString())
        .collection("Assignment")
        .get()
        .then((QuerySnapshot querySnapshot) =>
    {
      querySnapshot.docs.forEach((doc) {
        print("this is your happiness");
        print(doc["Assignment title"]);
      }),
    });
    ssteacherid = teacherid.toString();
    sssubjectname = subjectname.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Given Assignments'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (ShowClasses()),
    );
  }
}

class ShowClasses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(ssteacherid).document(sssubjectname).collection("Assignment").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.only(bottom: 15.0),
            child: new ListView(
              // ignore: deprecated_member_use
              children: snapshot.data.documents.map((document){
                //print(document['Assignment title']);
                var value = document['Assignment title'];
                var sub = document['Assignment Subtitle'];
                //var classlink = document['Assignment Link'];
                var samay = document['Assignment Deadline'];
                var kabtaksamay = document['Assignment Time'];
                var id = document.id;
                var assignlink = document['Assignment Link'];

                //subname=document.id;
                return new  Card(
                  shadowColor: Colors.lightBlueAccent,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => new ClassHome(value: value, id: coll)));
                      },
                      child: Container(
                        height: 150,
                        child: new Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 35, left: 30),
                                child: new Column(
                                  children: <Widget>[
                                    new Text(value, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                                    new Text(sub, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                                    new Text("Deadline :- $samay      $kabtaksamay", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.7,
                                      margin: EdgeInsets.only(left: 10),
                                      child: new RaisedButton(onPressed:
                                          (){
                                            Navigator.push(context,new MaterialPageRoute(builder: (context) => new ShowPdf(value: assignlink)));
                                          },
                                        elevation: 10,
                                        color: Colors.blue[900],
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Text("See Assignment", style: TextStyle(color: Colors.white),),
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

