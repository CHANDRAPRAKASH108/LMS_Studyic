import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studyivs/StudentOnly/class_overview.dart';
import 'package:studyivs/StudentOnly/profile.dart';
import 'package:studyivs/buycourses/studentuibuy.dart';
import 'homepageui.dart';

class HomeStudent extends StatefulWidget {
  @override
  _HomeStudentState createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudent> {
  @override
  @override
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePageUI(),
    ClassOverview(),
    ProfileStudent(),
  ];
  void OnTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    Future<bool> _onBackPressed() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit from App'),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text("NO"),
                ),
                SizedBox(height: 16),
                new GestureDetector(
                  onTap: () => SystemNavigator.pop(),
                  child: Text("YES"),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: OnTappedBar,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.class__outlined),
              title: new Text('My Classroom'),
            ),
            BottomNavigationBarItem(
                icon: new Icon(Icons.person_outline_outlined),
                title: new Text('Profile'))
          ],
        ),
      ),
    );
  }
}
