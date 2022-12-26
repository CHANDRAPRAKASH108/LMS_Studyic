import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

var showfilename = "no file selected";

class UploadAssignment extends StatefulWidget {
  @override
  _UploadAssignmentState createState() => _UploadAssignmentState();
}

class _UploadAssignmentState extends State<UploadAssignment> {
  @override
  AssignmentDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Upload File'),
            content: Column(
              children: <Widget>[
                Text(showfilename),
                SizedBox(
                  height: 10.0,
                ),
                RaisedButton(
                  onPressed: () {
                    uploadFile();
                  },
                  child: Text('Upload File'),
                ),
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5.0,
                  child: Text("Submit"),
                  onPressed: () async {
                    // DocumentReference messageRef = db .collection("rooms").document("roomA") .collection("messages").document("message1");
                    await FirebaseFirestore.instance
                        .collection('chandraprakash7543@gmail.com')
                        .document('Flutter')
                        .collection("upload")
                        .document()
                        .setData({
                      'Pdf link': "link",
                    }).then((onValue) {
                      print('Created it in sub collection');
                    }).catchError((e) {
                      print('======Error======== ' + e);
                    });
                    Navigator.of(context).pop();
                  }),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }

  @override
  CreateAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter Details'),
            content: Column(
              children: <Widget>[
                Text(showfilename),
                SizedBox(
                  height: 10.0,
                ),
                RaisedButton(
                  onPressed: () {
                    uploadFile();
                  },
                  child: Text('Upload File'),
                ),
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                  elevation: 5.0,
                  child: Text("Submit"),
                  onPressed: () async {
                    // DocumentReference messageRef = db .collection("rooms").document("roomA") .collection("messages").document("message1");
                    await FirebaseFirestore.instance
                        .collection('chandraprakash7543@gmail.com')
                        .document('Flutter')
                        .collection("upload")
                        .document()
                        .setData({
                      'Pdf link': "link",
                    }).then((onValue) {
                      print('Created it in sub collection');
                    }).catchError((e) {
                      print('======Error======== ' + e);
                    });
                    Navigator.of(context).pop();
                  }),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              )
            ],
          );
        });
  }

  Future uploadFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("hii"),
      ),
      body: Center(
        child: Text('Upload screen'),
      ),
    );
  }
}
