import 'package:cloud_FirebaseFirestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WardenHome extends StatefulWidget {
  String hostel;
  WardenHome({

    required this.hostel});
  @override
  _WardenHomeState createState() => _WardenHomeState(hostel);
}

class _WardenHomeState extends State<WardenHome> {
  String hostel;
  _WardenHomeState(this.hostel);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Applications for leave'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (ShowApplications(hostel))
    );
  }
}
class ShowApplications extends StatefulWidget {
  String hostel;
  ShowApplications(this.hostel);
  @override
  _ShowApplicationsState createState() => _ShowApplicationsState(hostel);
}

class _ShowApplicationsState extends State<ShowApplications> {
  String hostel;
  _ShowApplicationsState(this.hostel);
  @override
  Widget build(BuildContext context) {
    CreateAlertDialog(String email)async{
      return showDialog(context: context,builder: (context){
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text('Action Request'),
            content: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 30),
                    width: MediaQuery.of(context).size.width*0.7,
                    child: RaisedButton(
                      onPressed: ()async{
                        await FirebaseFirestore.instance.collection("Mentee").document(email).collection("Applications").document(email)
                            .updateData({"warden status":"Approved"});
                        Navigator.of(context).pop();
                      },
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      child:Text("Approve Request",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.7,
                    child: RaisedButton(
                      onPressed: ()async{
                        await FirebaseFirestore.instance.collection("Mentee").document(email).collection("Applications").document(email)
                            .updateData({"status":"Rejected"});
                        Navigator.of(context).pop();
                      },
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)
                      ),
                      child:Text("Reject Request",style: TextStyle(color: Colors.white),),
                    ),
                  )
                ]),
          ),
        );
      });
    }
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection(hostel).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            padding: EdgeInsets.all(15.0),
            margin: EdgeInsets.only(bottom: 15.0),
            child:  ListView(
              // ignore: deprecated_member_use
              children: snapshot.data!.docs.map((document){
                String name = document['name'];
                String regd_no = document['regd no'];
                String roll_no = document['roll no'];
                String till = document['till'];
                String from = document['from'];
                String description = document['description'];
                String status = document['teacher status'];
                String email = document['email'];
                String hostel = document['hostel'];
                String room = document['room'];
                print("Name is $name");
                return GestureDetector(
                  onLongPress: (){
                    CreateAlertDialog(email);
                  },
                  child: new  Card(
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
                          height: MediaQuery.of(context).size.height*0.5,
                          child: new Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> AccountIssue()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        //height: 70,
                                        width: MediaQuery.of(context).size.width*0.9,
                                        decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.blue[900]),
                                            borderRadius: BorderRadius.circular(15.0)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.2),
                                                child: Icon(Icons.person_outline_outlined,size: 25.0,color: Colors.blue[900],)),
                                            Text(name,style: TextStyle(fontSize: 15.0,color: Colors.blue[900],fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0,),
                                GestureDetector(
                                  onTap: (){
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutUs()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        //height: 70,
                                        width: MediaQuery.of(context).size.width*0.9,
                                        decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.blue[900]),
                                            borderRadius: BorderRadius.circular(15.0)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.6),
                                                child: Icon(Icons.format_list_numbered_outlined,size: 25.0,color: Colors.blue[900],)),
                                            Container(
                                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                                                child: Text(regd_no,style: TextStyle(fontSize: 15.0,color: Colors.blue[900]),)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0,),
                                GestureDetector(
                                  onTap: (){
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutUs()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        //height: 70,
                                        width: MediaQuery.of(context).size.width*0.9,
                                        decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.blue[900]),
                                            borderRadius: BorderRadius.circular(15.0)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.5),
                                                child: Icon(Icons.format_list_numbered_outlined,size: 25.0,color: Colors.blue[900],)),
                                            Container(
                                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                                                child: Text(roll_no,style: TextStyle(fontSize: 15.0,color: Colors.blue[900]),)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                GestureDetector(
                                  onTap: ()async{
                                    /*Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => new JustLogin(),
                                        ));*/
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0)
                                    ),
                                    //height: 70,
                                    width: MediaQuery.of(context).size.width*0.9,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.5),
                                            child: Text('From:- $from ',style: TextStyle(color: Colors.blue[900],fontSize: 15.0),)
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                                            child: Center(child: Text("Till:- $till",style: TextStyle(color: Colors.blue[900],fontSize: 15.0),))),
                                      ],
                                    ),
                                  ),
                                ), SizedBox(height: 10.0,),
                                GestureDetector(
                                  onTap: ()async{
                                    /*Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => new JustLogin(),
                                        ));*/
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0)
                                    ),
                                    //height: 70,
                                    width: MediaQuery.of(context).size.width*0.9,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/20),
                                            child: Center(child: SizedBox(
                                                width: MediaQuery.of(context).size.width*0.8,
                                                child: Text("Description:- $description",style: TextStyle(color: Colors.blue[900],fontSize: 15.0),)))),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15.0,),
                                GestureDetector(
                                  onTap: (){
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutUs()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        //height: 70,
                                        width: MediaQuery.of(context).size.width*0.9,
                                        decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.blue[900]),
                                            borderRadius: BorderRadius.circular(15.0)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.5),
                                                child: Text('Room Number:- $room',style: TextStyle(color: Colors.blue[900],fontSize: 15.0),)
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutUs()));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        //height: 70,
                                        width: MediaQuery.of(context).size.width*0.9,
                                        decoration: BoxDecoration(
                                          //border: Border.all(color: Colors.blue[900]),
                                            borderRadius: BorderRadius.circular(15.0)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.5),
                                                child: Text('Hostel Name:- $hostel',style: TextStyle(color: Colors.blue[900],fontSize: 15.0),)
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                          ),
                        ),
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

