import 'dart:async';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studyivs/ABOUT/aboutus.dart';
import 'package:studyivs/Teacher/Class/Scheduleclass.dart';
import 'package:studyivs/Teacher/Class/listofstudent.dart';
import 'package:studyivs/Teacher/Class/scheduleassignment.dart';
import 'package:studyivs/Teacher/Class/searchandadd.dart';
import 'package:studyivs/Teacher/Class/seescheduledclasses.dart';
import 'package:studyivs/Teacher/Class/showdaylist.dart';
import 'package:studyivs/Teacher/Class/showteacheruploadedcontent.dart';
import 'package:studyivs/Result/mainpage.dart';
import 'package:studyivs/StudentOnly/accountissue.dart';
import 'package:studyivs/Teacher/teachershowpost.dart';
import 'package:studyivs/UI/slidefromleft.dart';
import 'package:studyivs/mentor/teacherside.dart';
import 'package:studyivs/notepad/shownotes.dart';
import 'package:studyivs/padllete/teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyivs/update/lastupdated.dart';
import 'package:studyivs/usertype/selectuser.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

ProgressDialog progressDialog;
//String id,classname;
DateTime initial;
String currentday;

class ViewClasses extends StatefulWidget {
  String value, name, classday;
  ViewClasses({this.value, this.name, this.classday});
  @override
  _ViewClassesState createState() => _ViewClassesState(value, name, classday);
}

class _ViewClassesState extends State<ViewClasses> {
  String value, name, classday;
  String _timeString;
  _ViewClassesState(this.value, this.name, this.classday);
  @override
  void initState() {
    // TODO: implement initState
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    initial = DateTime.now();
    setState(() {
      currentday = DateFormat('EEEE').format(initial);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    Future<bool> _onBackPressed() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit from App ?'),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text("NO"),
                ),
                SizedBox(height: 20),
                new GestureDetector(
                  onTap: () => SystemNavigator.pop(),
                  child: Text("YES"),
                ),
              ],
            ),
          ) ??
          false;
    }

    String greetingMessage() {
      var timeNow = DateTime.now().hour;

      if (timeNow <= 12) {
        return 'Good Morning';
      } else if ((timeNow > 12) && (timeNow <= 16)) {
        return 'Good Afternoon';
      } else if ((timeNow > 16) && (timeNow < 20)) {
        return 'Good Evening';
      } else {
        return 'Good Evening';
      }
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Studyic',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromRadius(
              MediaQuery.of(context).size.height * 0.1,
            ),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: SizedBox(
                            child: Text(
                              "${greetingMessage() + "\n" + name}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Text(
                          DateFormat('hh:mm a').format(DateTime.now()),
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: Text(
                      'Your $currentday Scheduled Classes',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01)
                ],
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  child: DrawerHeader(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage("assets/images/avtarback.jpg"),
                            ),
                            SizedBox(
                                //width: MediaQuery.of(context).size.width * 0.5,
                                child: Text(
                              name,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic),
                            )),
                          ],
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: ListTile(
                    leading: Icon(
                      Icons.schedule,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Class Routine',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          SlideFromLeft(
                              widget: ShowDayList(
                            value: value,
                            name: name,
                          )));
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: ListTile(
                    leading: Icon(
                      Icons.person_outline_outlined,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Mentor',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          SlideFromLeft(
                              widget: TeacherSideMentor(
                            id: value,
                          )));
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: ListTile(
                    leading: Icon(
                      Icons.sports_soccer,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Social Media',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context, SlideFromLeft(widget: TeacherShowPost()));
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: ListTile(
                    leading: Icon(
                      Icons.link,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Results',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context, SlideFromLeft(widget: MainPage()));
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: ListTile(
                    leading: Icon(
                      Icons.assignment,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Notepad',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          SlideFromLeft(
                              widget: ShowNotes(
                            email: value,
                          )));
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: ListTile(
                    leading: Icon(
                      Icons.question_answer,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Self Help Center',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context, SlideFromLeft(widget: AccountIssue()));
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: ListTile(
                    leading: Icon(
                      Icons.sports_soccer,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Studyic Media',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          SlideFromLeft(
                              widget: ShowStudentUploaded(
                            email: value,
                          )));
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: ListTile(
                    leading: Icon(
                      Icons.description,
                      color: Colors.black,
                    ),
                    title: Text(
                      'About Us',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context, SlideFromLeft(widget: ShowAbout()));
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: ListTile(
                    leading: Icon(
                      Icons.login,
                      color: Colors.black,
                    ),
                    title: Text(
                      'LogOut',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.remove("teacheremail");
                      prefs.remove("teachervalue");
                      prefs.remove("name");
                      prefs.remove("userType");
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new Select_User(),
                          ));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: (FetchDayClass(value, name, classday)),
      ),
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }
}

class FetchDayClass extends StatefulWidget {
  String value, name, classday;
  FetchDayClass(this.value, this.name, this.classday);
  @override
  _FetchDayClassState createState() =>
      _FetchDayClassState(value, name, classday);
}

class _FetchDayClassState extends State<FetchDayClass> {
  String value, name, classday;
  _FetchDayClassState(this.value, this.name, this.classday);
  TextEditingController postcontroller = new TextEditingController();

  CreateAlertDialog(classname, id) {
    TextEditingController customcontroller = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text('Enter Details'),
              content: Column(children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter Your Id',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (text) {
                    emailstudent = customcontroller.text.toString();
                  },
                  controller: customcontroller,
                )
              ]),
              actions: <Widget>[
                MaterialButton(
                    elevation: 5.0,
                    child: Text("Delete"),
                    onPressed: () async {
                      progressDialog.show();
                      progressDialog.update(message: "Deleting Class");
                      if (emailstudent == value) {
                        await FirebaseFirestore.instance
                            .collection(value)
                            .doc(id)
                            .delete();
                        await FirebaseFirestore.instance
                            .collection("Teacher")
                            .doc(value)
                            .collection(classday)
                            .doc(id)
                            .delete();
                        Fluttertoast.showToast(
                            msg: "Class Deleted Successfully",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            textColor: Colors.white,
                            backgroundColor: Colors.black);
                        progressDialog.hide();
                        customcontroller.clear();
                      } else {
                        //progressDialog.hide();
                        Fluttertoast.showToast(
                            msg: "Please enter corect id",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 10,
                            textColor: Colors.white,
                            backgroundColor: Colors.black);
                      }
                    }),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal);

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Teacher")
            .doc(value)
            .collection(classday)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: Text('No Classes Found'));
          return Container(
            child: new ListView(
              children: snapshot.data.docs.map((document) {
                var id = document.id;
                var classname = document['class_name'];
                return ListTile(
                  leading: Image.asset("assets/images/logo.png"),
                  title: Text(
                    classname,
                    style: TextStyle(
                        color: Colors.blue[900], fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Timing:- $id"),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.blue[900],
                    onPressed: () {
                      CreateAlertDialog(classname, id);
                    },
                  ),
                  onTap: () {
                    showModalBottomSheet<void>(
                      isScrollControlled: true,
                      backgroundColor: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(45.0),
                            topRight: const Radius.circular(45.0)),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            //height: MediaQuery.of(context).size.height*0.5,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ListTile(
                                    leading: new Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                    ),
                                    title: new Text(
                                      'Schedule Classes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      //Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ScheduleClass(
                                                    firstdata: classname,
                                                    seconddata: value,
                                                  )));
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(
                                      Icons.calendar_today,
                                      color: Colors.white,
                                    ),
                                    title: new Text(
                                      'Scheduled Classes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      //Navigator.pop(context);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ScheduledClass(
                                                      subjectname: classname,
                                                      teacherid: value)));
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(
                                      Icons.assignment,
                                      color: Colors.white,
                                    ),
                                    title: new Text(
                                      'Schedule Assignment',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          SlideFromLeft(
                                              widget: ScheduleAssignment(
                                            firstdata: classname,
                                            seconddata: value,
                                          )));
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(
                                      Icons.question_answer,
                                      color: Colors.white,
                                    ),
                                    title: new Text(
                                      'Vote',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          SlideFromLeft(
                                              widget: CreatePadelete(
                                            subjectname: classname,
                                            teacherid: value,
                                          )));
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(
                                      Icons.assignment,
                                      color: Colors.white,
                                    ),
                                    title: new Text(
                                      'Post',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      //sharePost(classname);
                                      showModalBottomSheet<void>(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.blue[900],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(45.0),
                                              topRight:
                                                  const Radius.circular(45.0)),
                                        ),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SingleChildScrollView(
                                            child: Container(
                                              //height: MediaQuery.of(context).size.height*0.5,
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                              .viewInsets
                                                              .bottom),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        "Share Post",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18.0),
                                                      ),
                                                      SizedBox(
                                                        height: 20.0,
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              //bottom: MediaQuery.of(context).viewInsets.bottom
                                                              ),
                                                          child: TextField(
                                                            //style: TextStyle(color: Colors.white),
                                                            //cursorColor: Colors.white,
                                                            maxLines: 10,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Write Here",
                                                              fillColor:
                                                                  Colors.white,
                                                              filled: true,
                                                              //labelStyle: TextStyle(color: Colors.white),
                                                            ),
                                                            controller:
                                                                postcontroller,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            //bottom: MediaQuery.of(context).viewInsets.bottom
                                                            ),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.8,
                                                          child: RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      value)
                                                                  .doc(
                                                                      classname)
                                                                  .collection(
                                                                      "Post")
                                                                  .doc()
                                                                  .setData({
                                                                'post_link':
                                                                    postcontroller
                                                                        .text
                                                                        .toString()
                                                              });
                                                              lastupdated(value,
                                                                  classname);
                                                              postcontroller
                                                                  .clear();
                                                            },
                                                            color: Colors.white,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0)),
                                                            child: Text(
                                                              'Share Post',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .blue[
                                                                      900]),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    title: new Text(
                                      'Add Student',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          SlideFromLeft(
                                              widget: SearchAndAdd(
                                            firstdata: classname,
                                            seconddata: value,
                                          )));
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(
                                      Icons.supervisor_account_sharp,
                                      color: Colors.white,
                                    ),
                                    title: new Text(
                                      'List Of Student',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          SlideFromLeft(
                                              widget: StudentList(
                                            subjectname: classname,
                                            teacherid: value,
                                          )));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }).toList(),
            ),
          );
        });
  }
}
