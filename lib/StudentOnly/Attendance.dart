import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:studyivs/StudentOnly/Assignment.dart';
import 'package:studyivs/StudentOnly/Post.dart';
import 'package:studyivs/StudentOnly/scheduled_class.dart';
import 'package:studyivs/padllete/student.dart';

//String mailIdUser;
//String subjectName;
int numClasses;
double present;
double totalClasses;
double absent;
double percentage;
//int productCount = 5;
Map<String, double> dataMap;
bool _isloading = false;
class Attendance extends StatefulWidget {
  String subName;
  String mailId,teacherid;
  //double numClasses;
  Attendance({this.subName, this.mailId,this.teacherid});
  @override
  _AttendanceState createState() => _AttendanceState(subName, mailId,teacherid);
}

class _AttendanceState extends State<Attendance> {
  String subName;
  String mailId,teacherid;
  _AttendanceState(this.subName, this.mailId,this.teacherid);

  @override
  void initState() {
    super.initState();
    FetchData();
  }

  FetchData()async{
    await FirebaseFirestore.instance
        .collection(mailId)
        .document(subName)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists){
        int attendanceCounter =
        documentSnapshot.data()["Attendance Counter"];
        present = attendanceCounter.toDouble();
        Firestore.instance
            .collection(mailId)
            .document(subName)
            .collection("classes")
            .get()
            .then((querySnapshot) {
          numClasses = querySnapshot.size;
        });
        setState(() {
          absent = numClasses.toDouble() - present;
          percentage = (present / numClasses.toDouble()) * 100;
        });
        dataMap = {
          "Absent": absent,
          "Present": present,
        };
        setState(() {
          _isloading = true;
        });
      } else {
        _isloading = false;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
        appBar: AppBar(
          title: Text('Attendance'),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
        ),
        body: (_isloading ? ShowAttendance(dataMap) : null),
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

class ShowAttendance extends StatelessWidget{
  Map<String, double> dataMap;
  ShowAttendance(this.dataMap);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            color: Colors.teal[100],
            width: MediaQuery.of(context).size.width * 0.7,
            height: 90,
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: <Widget>[
                Text(" Present :" + present.toString()),
                Text("Absent :" + absent.toString()),
                Text("Percentage :" + percentage.toString() + "%"),
              ],
            ),
          ),
          SizedBox(
            height: 45,
          ),
          PieChart(
            dataMap: dataMap,
            animationDuration: Duration(milliseconds: 500),
            chartLegendSpacing: 52,
            chartRadius: MediaQuery.of(context).size.width / 2.0,
            initialAngleInDegree: 90,
            chartType: ChartType.ring,
            ringStrokeWidth: 100,
            centerText: "Attendance",
            legendOptions: LegendOptions(
              showLegendsInRow: true,
              legendPosition: LegendPosition.bottom,
              showLegends: true,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: false,
              showChartValuesOutside: false,
            ),
          ),
        ],
      ),
    );
  }
}