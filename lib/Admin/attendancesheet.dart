import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoIt extends StatelessWidget {
  String teacherid,subname,regd;
  DoIt({this.teacherid,this.subname,this.regd});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: Text('Attendance Sheet'),
backgroundColor: Colors.blue[900],
centerTitle: true,
    ),
      body: (AttendanceSheet(teacherid,subname,regd,)),
    );
  }
}

class AttendanceSheet extends StatelessWidget {
  String teacherid,subname,regd;
  AttendanceSheet(this.teacherid,this.subname,this.regd);
  @override
  Widget build(BuildContext context) {
    print("teacher $teacherid");
    print("teacher $subname");
    print("teacher $regd");
    return StreamBuilder(
        stream: Firestore.instance.collection(regd).doc(subname).collection("classes").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            child: new ListView(
              children: snapshot.data.documents.map((document){
                bool attended = document['hasAttended'];
                var id = document.id;
                return new  ListTile(
                    leading: Icon(Icons.person_outline_outlined),
                    title: Text(id),
                    subtitle: Text("Present:-"+attended.toString()),
                  );
              }).toList(),
            ),
          );
        }
    );
  }
}
