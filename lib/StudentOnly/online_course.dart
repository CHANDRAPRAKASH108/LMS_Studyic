import 'package:flutter/services.dart';
import 'package:studyivs/StudentOnly//class_join_view.dart';
import 'package:studyivs/StudentOnly//model/syllabus_model.dart';
import 'package:flutter/material.dart';
import './model/constants.dart';

class OnlineCourses extends StatefulWidget {
  @override
  _OnlineCoursesState createState() => _OnlineCoursesState();
}

class _OnlineCoursesState extends State<OnlineCourses> {
  List<Widget> itemsData = [];

  void getPostsData() {
    List<dynamic> responseList = ONLINE_COURSE_DATA;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      String link = post["link"];
      listItems.add(GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ClassJoinView(link)));
          },
          child: Container(
              padding: EdgeInsets.all(7),
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(100), blurRadius: 10.0),
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          post["name"],
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold,color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              ))));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text("Online Courses"),
        centerTitle: true,
      ),
      backgroundColor: Colors.purple,
      body: Container(
        color: Colors.grey[200],
        height: size.height,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: itemsData.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return itemsData[index];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
