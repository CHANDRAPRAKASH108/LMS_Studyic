import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:studyivs/ABOUT/aboutus.dart';
import 'package:studyivs/Result/mainpage.dart';
import 'package:studyivs/UI/cards.dart';
import 'package:studyivs/UI/listtile.dart';
import 'package:studyivs/UI/scrollablecard.dart';
import 'package:studyivs/buycourses/studentuibuy.dart';
import 'package:studyivs/mentor/studentmentor.dart';
import 'package:studyivs/notepad/shownotes.dart';
import 'package:studyivs/usertype/selectuser.dart';
import '../Payment.dart';
import 'Studentshowpost.dart';
import 'accountissue.dart';

var _image;
String name, url, regd;
DateTime time;

class HomePageUI extends StatefulWidget {
  @override
  _HomePageUIState createState() => _HomePageUIState();
}

class _HomePageUIState extends State<HomePageUI> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    greetingMessage();
  }

  @override
  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("sname");
      url = prefs.getString("simageurl");
      regd = prefs.getString("regd_no");
    });
  }

  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow <= 12) {
      _image = "assets/images/sun.png";
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      _image = "assets/images/sun.png";
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      _image = "assets/images/moon.png";
      return 'Good Evening';
    } else {
      _image = "assets/images/moon.png";
      return 'Good Night';
    }
  }

  Widget build(BuildContext context) {
    var sized = MediaQuery.of(context);
    final GoogleSignIn _gSignIn = GoogleSignIn();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Studyic',
          style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        color: Colors.blue[900],
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                color: Colors.blue[900],
                child: DrawerHeader(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.blue[900],
                            backgroundImage: NetworkImage(url),
                          ),
                          SizedBox(height:5.0),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(name,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ListTiel(
                  widget: ShowStudentPost(),
                  titletxt: 'SocialMedia',
                  icon: Icons.network_check_outlined),
              ListTiel(
                  widget: MainPage(),
                  titletxt: 'Results',
                  icon: Icons.assignment),
              ListTiel(
                  widget: ShowNotes(
                    email: regd,
                  ),
                  titletxt: 'Notepad',
                  icon: Icons.assignment),
              ListTiel(
                widget: AccountIssue(),
                titletxt: 'Account Issue',
                icon: Icons.person_outline_outlined,
              ),
              ListTiel(
                widget: ShowAbout(),
                titletxt: 'About Us',
                icon: Icons.description,
              ),
              ListTile(
                leading: Icon(Icons.login),
                title: Text(
                  'LogOut',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  await _gSignIn.signOut();
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new Select_User(),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: SafeArea(
            child: Container(
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          width: sized.size.width * 1.0,
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40.0),
                                bottomRight: Radius.circular(40.0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: sized.size.height * 0.03,
                                      ),
                                      Text(
                                        greetingMessage(),
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: sized.size.height * 0.02,
                                      ),
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.67,
                                          child: Text(
                                            name.toUpperCase(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    sized.size.width * 0.04,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                  // SizedBox(
                                  //   width: sized.size.width * 0.1,
                                  // ),
                                  // Text(
                                  //   DateFormat('hh:mm a')
                                  //       .format(DateTime.now()),
                                  //   style: TextStyle(
                                  //       color: Colors.white,
                                  //       fontSize: sized.size.width * 0.04),
                                  // ),
                                  Image(
                                    image: AssetImage(_image),
                                    height: sized.size.height * 0.08,
                                    width: sized.size.width * 0.1,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: sized.size.height * 0.045,
                              ),
                              Container(
                                  child: CarouselSlider(
                                items: [
                                  ScrollableCard(
                                      'assets/images/summentor.png',
                                      StudentMentor(
                                        email: regd,
                                      )),
                                  ScrollableCard('assets/images/summedia.png',
                                      ShowStudentPost()),
                                  ScrollableCard(
                                      'assets/images/sumnote.png',
                                      ShowNotes(
                                        email: regd,
                                      )),
                                ],
                                options: CarouselOptions(
                                  height:
                                      MediaQuery.of(context).size.height * 0.26,
                                  enlargeCenterPage: true,
                                  autoPlay: true,
                                  aspectRatio: 16 / 9,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enableInfiniteScroll: true,
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  viewportFraction: 0.8,
                                ),
                              )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: sized.size.height * 0.02,
                        ),
                        StudentCard("assets/images/sumonline.png", BuyUi()),
                        SizedBox(
                          height: sized.size.height * 0.02,
                        ),
                        StudentCard(
                            "assets/images/summentor.png",
                            StudentMentor(
                              email: regd,
                            )),
                        SizedBox(
                          height: sized.size.height * 0.02,
                        ),
                        StudentCard("assets/images/sumpayment.png", Donate()),
                        SizedBox(
                          height: sized.size.height * 0.02,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
