import 'dart:io';

import 'package:flutter/services.dart';
import 'package:studyivs/StudentOnly//class_join_view.dart';
import 'package:studyivs/StudentOnly//result/webviewresult.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// getlink;
class GetSemester extends StatefulWidget {
  String fieldname, resulttype, yearname;
  GetSemester({this.resulttype, this.yearname, this.fieldname});
  @override
  _GetSemesterState createState() =>
      _GetSemesterState(resulttype, yearname, fieldname);
}

class _GetSemesterState extends State<GetSemester> {
  String fieldname, resulttype, yearname;
  _GetSemesterState(this.resulttype, this.yearname, this.fieldname);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Semester'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (SelectSemester(fieldname, resulttype, yearname)),
    );
  }
}

class SelectSemester extends StatelessWidget {
  String fieldname, resulttype, yearname;
  SelectSemester(this.fieldname, this.resulttype, this.yearname);
  @override
  Widget build(BuildContext context) {
    print("fieldname $fieldname yearname $yearname resulttype $resulttype");
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Result")
            .document(fieldname)
            .collection(fieldname)
            .document(resulttype)
            .collection(resulttype)
            .document(yearname)
            .collection(yearname)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: new CircularProgressIndicator());
          return Container(
            child: new ListView(
              children: snapshot.data.documents.map((document) {
                var semname = document.id;
                print(semname);
                return new Card(
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
                        child: new Row(children: <Widget>[
                          Container(
                            child: new Column(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  child: new RaisedButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("Result")
                                          .document(fieldname)
                                          .collection(fieldname)
                                          .document(resulttype)
                                          .collection(resulttype)
                                          .document(yearname)
                                          .collection(yearname)
                                          .document(semname)
                                          .get()
                                          .then((DocumentSnapshot snapshot) {
                                        if (snapshot.exists) {
                                          var getlink = snapshot['Link'];
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new WebViewResult(
                                                        Link: getlink,
                                                      )));
                                        }
                                      });
                                    },
                                    elevation: 10,
                                    color: Colors.blue[900],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width*0.8,
                                      child: Text(
                                        semname,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ));
              }).toList(),
            ),
          );
        });
  }
}
