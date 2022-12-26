import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:studyivs/StudentOnly/studenthomeui.dart';
import 'package:studyivs/Teacher/Class/ViewClasses.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyivs/usertype/selectuser.dart';
import 'package:splashscreen/splashscreen.dart';
var tename,value,sname,semail,simageurl,usertype,regd;
Future<void> main()
async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
   tename = prefs.getString("name");
   value = prefs.getString("teachervalue");
   sname = prefs.getString("sname");
   semail = prefs.getString("semail");
   simageurl = prefs.getString("simageurl");
   usertype = prefs.getString("userType");
   regd = prefs.getString("regd_no");

    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
        brightness: Brightness.light,
        indicatorColor: Colors.blue[900],
        canvasColor: Colors.white,
        primaryColorDark: Colors.blue[900]
      ),
      // darkTheme: ThemeData(
      //     primaryColor: Colors.black,
      //     primaryColorBrightness: Brightness.dark,
      //     primaryColorLight: Colors.black,
      //     brightness: Brightness.dark,
      //     primaryColorDark: Colors.white,
      //     indicatorColor: Colors.white,
      //     canvasColor: Colors.black,
      //     appBarTheme: AppBarTheme(brightness: Brightness.dark)),
      home: MyApp(),
    )
    );
  }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String currentday="currentday";
  DateTime initial=DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial = DateTime.now();
    currentday = DateFormat('EEEE').format(initial);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  SplashScreen(
          seconds: 5,
          navigateAfterSeconds: usertype == null ? Select_User() :( usertype == 'student' ?  HomeStudent() : ViewClasses(value: value,name: tename,classday: currentday,)),
          title: Text('Studyic',
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              color: Colors.white
            ),),
          image: new Image.asset("assets/images/book.gif"),
          backgroundColor: Theme.of(context).primaryColor,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          onClick: ()=>print("Flutter Egypt"),
          loaderColor: Colors.white
      ),
    );
  }
}
