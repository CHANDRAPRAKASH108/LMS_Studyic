import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:studyivs/padllete/student.dart';

String qno,question,option1,option2,option3,option4,answer;
class CreatePadelete extends StatefulWidget {
  String subjectname,teacherid;
  CreatePadelete({this.subjectname,this.teacherid});
  @override
  _CreatePadeleteState createState() => _CreatePadeleteState(subjectname,teacherid);
}

class _CreatePadeleteState extends State<CreatePadelete> {
  String subjectname,teacherid;
  _CreatePadeleteState(this.subjectname,this.teacherid);
  @override
  CreateAlertDialog(BuildContext context){
    // String email = detailTeacher.teacheremail;
    TextEditingController qnocontroller = TextEditingController();
    TextEditingController questioncontroller = TextEditingController();
    TextEditingController option1controller = TextEditingController();
    TextEditingController option2controller = TextEditingController();
    TextEditingController option3controller = TextEditingController();
    TextEditingController option4controller = TextEditingController();
    TextEditingController answercontroller = TextEditingController();

    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text('Enter Details'),
        content: SingleChildScrollView(
          child: Column(
              children: <Widget>[
                TextField
                  (
                  decoration: InputDecoration(
                      hintText: "Enter question number"
                  ),
                  onChanged: (text)
                  {
                    qno=qnocontroller.text.toString();
                  },
                  keyboardType: TextInputType.number,
                  controller: qnocontroller,
                ),
                TextField
                  (
                  decoration: InputDecoration(
                      hintText: "Enter your question ?"
                  ),
                  onChanged: (text){
                    setState(() {
                      question=questioncontroller.text.toString();
                    });
                  },
                  controller: questioncontroller,
                ),
                TextField
                  (
                  decoration: InputDecoration(
                      labelText: "option A"
                  ),
                  onChanged: (text){
                    setState(() {
                      option1=option1controller.text.toString();
                    });
                  },
                  controller: option1controller,
                ),
                TextField
                  (
                  decoration: InputDecoration(
                      labelText: "option B"
                  ),
                  onChanged: (text){
                    setState(() {
                      option2=option2controller.text.toString();
                    });
                  },
                  controller: option2controller,
                ),
                TextField
                  (
                  decoration: InputDecoration(
                      labelText: "option C"
                  ),
                  onChanged: (text){
                    setState(() {
                      option3=option3controller.text.toString();
                    });
                  },
                  controller: option3controller,
                ),
                TextField
                  (
                  decoration: InputDecoration(
                      labelText: "option D"
                  ),
                  onChanged: (text){
                    setState(() {
                      option4=option4controller.text.toString();
                    });
                  },
                  controller: option4controller,
                ),
                TextField
                  (
                  decoration: InputDecoration(
                      labelText: "answer"
                  ),
                  onChanged: (text){
                    setState(() {
                      answer=answercontroller.text.toString();
                    });
                  },
                  controller: answercontroller,
                ),
              ]),
        ),
        actions: <Widget>[
          MaterialButton(
              elevation: 5.0,
              child: Text("Submit"),
              onPressed: () async {
                // DocumentReference messageRef = db .collection("rooms").document("roomA") .collection("messages").document("message1");
                await Firestore.instance
                    .collection(teacherid)
                    .document(subjectname)
                    .collection("Padellete")
                    .document("Padellete")
                    .setData({
                  'Qno': qno,
                  'Question': question,
                  'option1': option1,
                  'option2': option2,
                  'option3': option3,
                  'option4': option4,
                  'answer': answer,
                  'vote1':"0",
                  'vote2':"0",
                  'vote3':"0",
                  'vote4':"0"
                }).then((onValue) {
                  //print('Created it in sub collection');
                }).catchError((e) {
                  //print('======Error======== ' + e);
                });

                final usersRef = Firestore.instance.collection("7543")
                    .document("Flutter")
                    .collection("7543");
                
                usersRef.getDocuments().then((QuerySnapshot snapshot){
                  snapshot.documents.forEach((DocumentSnapshot doc) async{
                    var studenteamil = doc.id;

                    Firestore.instance.collection(studenteamil).document("Flutter").collection("Padellete").document("Padellete")
                    .setData({
                      'teacherid': "7543"
                    }).then((onValue) {
                      //print('Created it in sub collection');
                    }).catchError((e) {
                      //print('======Error======== ' + e);
                    });

                  });
                });
                
              })
        ],
      );
    });
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Voting'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (ShowCreatedPadlete(subjectname: subjectname, teacherid: teacherid)),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          CreateAlertDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[900],
      ),
    );
  }
}

class ShowCreatedPadlete extends StatefulWidget {
  String subjectname,teacherid;
  ShowCreatedPadlete({this.subjectname,this.teacherid});
  @override
  _ShowCreatedPadleteState createState() => _ShowCreatedPadleteState(subjectname,teacherid);
}

class _ShowCreatedPadleteState extends State<ShowCreatedPadlete> {
  String subjectname,teacherid;
  _ShowCreatedPadleteState(this.subjectname,this.teacherid);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection(teacherid).document(subjectname).collection("Padellete").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(child: new CircularProgressIndicator());
          return Container(
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.only(bottom: 15.0),
            child: new ListView(
              // ignore: deprecated_member_use
              children: snapshot.data.documents.map((document) {
                var getqno = document['Qno'];
                var getquestion = document['Question'];
                var getoption1 = document['option1'];
                var getoption2 = document['option2'];
                var getoption3 = document['option3'];
                var getoption4 = document['option4'];
                var getanswer = document['answer'];
                var voteone = document['vote1'];
                var votetwo = document['vote2'];
                var votethree = document['vote3'];
                var votefour = document['vote4'];

                print("this is .........get question $getquestion");
                return Card(
                  elevation: 10,
                  shadowColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.7,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 22),
                                          width: MediaQuery.of(context).size.width*0.8,
                                          child: RaisedButton(onPressed: (){
                                          }, child: Text("$getoption1",style: TextStyle(color: Colors.white),),
                                            color: Colors.blue[900],
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0)
                                          ),
                                          ),
                                        )
                                      ]
                                  ),
                                ),
                                SizedBox(height: 20.0,),
                                Container(
                                  child: Text('Number of votes :- $voteone'),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 22),
                                          width: MediaQuery.of(context).size.width*0.8,
                                          child: RaisedButton(onPressed: (){
                                          }, child: Text("$getoption2",style: TextStyle(color: Colors.white),),
                                            color: Colors.blue[900],
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                            ),
                                          ),
                                        )
                                      ]
                                  ),
                                ),
                                SizedBox(height: 20.0,),
                                Container(
                                  child: Text('Number of votes :- $votetwo'),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 22),
                                          width: MediaQuery.of(context).size.width*0.8,
                                          child: RaisedButton(onPressed: (){
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
                                SizedBox(height: 20.0,),
                                Container(
                                  child: Text('Number of votes :- $votethree'),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(left: 22),
                                          width: MediaQuery.of(context).size.width*0.8,
                                          child: RaisedButton(onPressed: (){
                                           // Navigator.push(context, new MaterialPageRoute(builder: (context) => new StudentPadellete()));
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
                                SizedBox(height: 20.0,),
                                Container(
                                  child: Text('Number of votes:- $votefour'),
                                )
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

