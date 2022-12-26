import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studyivs/login/justlogin.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_dialog/progress_dialog.dart';

String email="email";
String emailact="emailact";

class ForgotPass extends StatefulWidget {
  @override
  _ForgotPassState createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  @override
  TextEditingController emailcontroller = new TextEditingController();
  ShowMessage() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Successfull'),
            content: Text('Password successfully sent to your email id.'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  emailcontroller.clear();
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              )
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    ProgressDialog progressDialog = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
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
                      height: 150,
                      image: AssetImage('assets/images/studyic.png'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Text(
                      "Forgot Password",
                      style:
                          TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Enter Email",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                      onChanged: (text) {
                        email = emailcontroller.text.toString();
                      },
                      controller: emailcontroller,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 50,
                    child: RaisedButton(
                      onPressed: () async {
                        if (email != null) {
                          progressDialog.show();
                          progressDialog.update(message: "Requesting..");
                          String username = 'studynotes600@gmail.com';
                          String password = 'Study@2021';
                          progressDialog.update(message: "Sending Mail...");
                          final snapShot = await FirebaseFirestore.instance
                              .collection('Teacher')
                              .document(email)
                              .get();
                          if (snapShot.exists) {
                            String pass = snapShot['password'];
                            emailact = snapShot['email'];
                            final smtpServer = gmail(username, password);
                            final message = Message()
                              ..from = Address(username)
                              ..recipients.add(emailact)
                              // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
                              // ..bccRecipients.add(Address('bccAddress@example.com'))
                              ..subject = 'Password Reset'
                              ..text = ''
                              ..html =
                                  "<p>You are requested for the forgot password.<br> Your password is attached with this mail you can login with this password<br>Your Password:- $pass</p><h1>Thanks & Regards studyic</h1>\n<p>C.V.RAMAN GLOBAL UNIVERSITY</p>";

                            try {
                              final sendReport = await send(message, smtpServer);
                              print('Message sent: ' + sendReport.toString());
                              progressDialog.hide();
                              ShowMessage();
                            } on MailerException catch (e) {
                              print('Message not sent.');
                              for (var p in e.problems) {
                                print('Problem: ${p.code}: ${p.msg}');
                                progressDialog.hide();
                                Fluttertoast.showToast(
                                    msg: "Please enter valid email id",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.red,
                                    backgroundColor: Colors.white);
                              }
                            }
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Email is required",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.red,
                              backgroundColor: Colors.white);
                        }
                      },
                      child: Text(
                        'Show Password',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Divider(
                      color: Colors.blue[900],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => new JustLogin()));
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text(
                        "Back to login",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
