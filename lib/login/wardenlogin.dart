import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studyivs/login/justlogin.dart';
import 'package:studyivs/login/wardenhome.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

String username="username", password="password";

class WardenLogin extends StatefulWidget {
  @override
  _WardenLoginState createState() => _WardenLoginState();
}

class _WardenLoginState extends State<WardenLogin> {
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    GetSignedIn() async {
      progressDialog.show();
      progressDialog.update(message: "Authenticating");
      progressDialog.update(message: "Logging In");
      FirebaseFirestore.instance
          .collection("Warden")
          .document(username)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          String pass = snapshot['password'];
          String hostel = snapshot['hostel'];
          if (password == pass) {
            progressDialog.hide();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WardenHome(hostel: hostel)));
            passwordcontroller.clear();
            usernamecontroller.clear();
          } else {
            progressDialog.hide();
            Fluttertoast.showToast(
                msg: "Password dosen't match with the user id",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                textColor: Colors.red,
                backgroundColor: Colors.white);
          }
        } else {
          progressDialog.hide();
          Fluttertoast.showToast(
              msg: "Userid dosent found",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              textColor: Colors.red,
              backgroundColor: Colors.white);
        }
      });
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
        body: SingleChildScrollView(
          child: (Center(
            child: Container(
              padding: EdgeInsets.only(top: 150.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor,
                          offset: Offset(5.0, 5.0),
                          blurRadius: 5.0,
                          spreadRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Image(
                        height: MediaQuery.of(context).size.height * 0.2,
                        image: const AssetImage('assets/images/studyic.png')),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    child: const Text('Warden Login',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Enter Username",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      controller: usernamecontroller,
                      onChanged: (text) {
                        username = usernamecontroller.text.toString();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Enter Password",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      controller: passwordcontroller,
                      obscureText: true,
                      onChanged: (text) {
                        password = passwordcontroller.text.toString();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: RaisedButton(
                      onPressed: () {
                        GetSignedIn();
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        //padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/5),
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Divider(
                      color: Colors.blue[900],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text('I am not a warden ?'),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JustLogin()));
                        },
                        child: Container(
                          child: Text(
                            'Back to login',
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
        ),
      );
  }
}
