import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studyivs/StudentOnly/studenthomeui.dart';
import 'package:studyivs/login/justlogin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

var name;
String _name="_name", _email="email", _regdno="regdno", _college="college", _roll="roll";

class Select_User extends StatefulWidget {
  @override
  _Select_UserState createState() => _Select_UserState();
}

class _Select_UserState extends State<Select_User> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();
    //ProgressDialog progressDialog = ProgressDialog(context, type: ProgressDialogType.Normal,isDismissible: false);

    ShowMessage() {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Alert'),
              content: Text(
                  'Your email Id is not registered with any partnered institution'),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Ok'),
                )
              ],
            );
          });
    }

    Future<FirebaseUser> _signIn(BuildContext) async {
      final GoogleSignInAccount googleuser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleuser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      UserCredential userDetails =
          await _firebaseAuth.signInWithCredential(credential);
      String email = _googleSignIn.currentUser.email;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await Firestore.instance
          .collection("Student")
          .where("email", isEqualTo: _googleSignIn.currentUser.email)
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          setState(() {
            _name = doc['name'];
            _email = doc['email'];
            _regdno = doc['regd_no'];
            _college = doc['college_name'];
            _roll = doc['roll_no'];
          });
        });
      });
      if (_name != null) {
        prefs.setString("sname", _name);
        prefs.setString("semail", _email);
        prefs.setString("simageurl", _googleSignIn.currentUser.photoUrl);
        prefs.setString("regd_no", _regdno);
        prefs.setString("userType", 'student');
        prefs.setString("college", _college);
        prefs.setString("roll", _roll);
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    HomeStudent(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(-1.0, 0.0), end: Offset.zero)
                        .animate(animation),
                    child: SlideTransition(
                      position: Tween<Offset>(
                              begin: Offset.zero, end: const Offset(-1.0, 0.0))
                          .animate(secondaryAnimation),
                      child: child,
                    ),
                  );
                }));
      } else {
        _googleSignIn.signOut();
        _firebaseAuth.signOut();
        ShowMessage();
      }
      //return userDetails;
    }

    // Future<bool> _onBackPressed() {
    //   return showDialog(
    //         context: context,
    //         builder: (context) => new AlertDialog(
    //           title: new Text('Are you sure?'),
    //           content: new Text('Do you want to exit from App'),
    //           actions: <Widget>[
    //             new GestureDetector(
    //               onTap: () => Navigator.of(context).pop(false),
    //               child: Text("NO"),
    //             ),
    //             SizedBox(height: 16),
    //             new GestureDetector(
    //               onTap: () => SystemNavigator.pop(),
    //               child: Text("YES"),
    //             ),
    //           ],
    //         ),
    //       ) ??
    //       false;
    // }

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Container(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Text(
                      'Studyic',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.1,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                Container(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    child: Text(
                      'WE MAKE YOUR LEARNING EXPERIENCE EASIER',
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                Container(
                    child: Image(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.height * 0.1,
                  image: AssetImage("assets/images/book.gif"),
                )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.43,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      onPressed: () {
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
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          "Student Login",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0),
                                        ),
                                        SizedBox(
                                          height: 30.0,
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            child: Text(
                                              "Please proceed with google singIn with the email that is registered with your college or institution",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0),
                                            )),
                                        SizedBox(
                                          height: 20.0,
                                        ),
                                        Container(
                                          color: Colors.blue[900],
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.56,
                                          child: RaisedButton(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0)),
                                            onPressed: () {
                                              _signIn(context);
                                            },
                                            child: Image(
                                              image: AssetImage(
                                                  "assets/images/google.png"),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        'Continue As Student',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.01),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JustLogin()));
                      },
                      child: Text(
                        'Continue As Teacher',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
