import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studyivs/Teacher/Class/webview.dart';

var sssubjectname;
var ssteacherid;
var sslink;
class ScheduledClass extends StatefulWidget {
  var subjectname;
  var teacherid;

  ScheduledClass({this.subjectname,this.teacherid});
  @override
  _ScheduledClassState createState() => _ScheduledClassState(subjectname,teacherid);
}

class _ScheduledClassState extends State<ScheduledClass> {
  var subjectname;
  var teacherid;

  _ScheduledClassState(this.subjectname, this.teacherid);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    FirebaseFirebaseFirestore.instance
        .collection(teacherid.toString())
    .document(subjectname.toString())
    .collection("classes")
    .orderBy("Timestamp")
        .get()
        .then((QuerySnapshot querySnapshot) =>
    {
      querySnapshot.docs.forEach((doc) {
        print("this is your happiness");
        print(doc["Teacher.Class title"]);
      }),
    });
    ssteacherid = teacherid.toString();
    sssubjectname = subjectname.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Your scheduled classes'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (ShowClasses()) ,
    );
  }
}

class ShowClasses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(ssteacherid).document(sssubjectname).collection("classes").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.only(bottom: 15.0),
            child: new ListView(
              // ignore: deprecated_member_use
              children: snapshot.data.documents.map((document){
                var value = document['Class_title'];
                var sub = document['Class_Subtitle'];
                var classlink = document['Class_link'];
                var samay = document['date'];
                var time = document['time'];

                //subname=document.id;
                return new  Card(
                  //color: Colors.lightBlueAccent,
                    shadowColor: Colors.lightBlueAccent,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        //side: BorderSide(width: 5,color: Colors.black54)
                    ),
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                       // Navigator.push(context, MaterialPageRoute(builder: (context) => new ClassHome(value: value, id: coll)));
                      },
                      child: Container(
                        height: 170,
                        child: new Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 35, left: 30),
                                child: new Column(
                                  children: <Widget>[
                                    new Text(value, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                                    new Text(sub, style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                                    new Text("Scheduled On:- $samay", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                                    new Text("Time :- $time", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                                    //new Text(classlink, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                                      Container(
                                        width: MediaQuery.of(context).size.width*0.7,
                                        margin: EdgeInsets.only(left: 10),
                                        child: new RaisedButton(onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => new WebView(classlink: classlink)));
                                        },
                                          elevation: 10,
                                          color: Colors.blue[900],
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              //side: BorderSide(width: 5,color: Colors.black54)
                                          ),
                                        child: Text("Join Now", style: TextStyle(color: Colors.white),),
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
