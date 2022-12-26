import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:studyivs/StudentOnly/Assignment.dart';

String subName;
DateTime myDateTime;
Timestamp timeStamp;
String uploadurl, score;
String mailId;
List<String> selectedfile;
var _object;
var uploadPdfUrl;
ProgressDialog pd;
String assignmentTitle;
bool assignmentupload = false;
class UploadAssignmentStudent extends StatefulWidget {
  String deadlineTime,deadline,value,subjectName,userEmailId;
  UploadAssignmentStudent({this.deadlineTime,this.deadline,this.value,this.subjectName,this.userEmailId});
  @override
  _UploadAssignmentStudentState createState() => _UploadAssignmentStudentState(deadlineTime,deadline,value,subjectName,userEmailId);
}

class _UploadAssignmentStudentState extends State<UploadAssignmentStudent> {
  String deadlineTime,deadline,value,subjectName,userEmailId;
  _UploadAssignmentStudentState(this.deadlineTime,this.deadline,this.value,this.subjectName,this.userEmailId);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      subName = subjectName;
      mailId = userEmailId;
      assignmentTitle = value;
    });
    print("this is subname $subName");
    print("this is mail $mailId");
    print("this is asstitle $assignmentTitle");
  }
  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context, type: ProgressDialogType.Normal);
    FinalCall() {
      pd.show();
      pd.update(message: "Uploading Assignment");
      var rng = new Random();
      String randomName = "";
      for (var i = 0; i < 20; i++) {
        randomName += rng.nextInt(100).toString();
      }
      File file = File(_object.files.single.path);
      String fileName = '${randomName}.pdf';
      print(fileName);
      print('${file.readAsBytesSync()}');
      savePdf(file.readAsBytesSync(), fileName);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(value),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        color: Colors.white70,
        height: MediaQuery.of(context).size.height*0.9,
        child: Card(
          child: Center(
            child: (
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: Text("Assignment :- $value",style: TextStyle(color: Colors.blue[900],fontSize: 20.0,fontWeight: FontWeight.bold),)),
                  SizedBox(height: 50.0,),
                  Container(
                      child: Text("Please upload the assignment only in PDF format",style: TextStyle(color: Colors.blue[900],fontSize: 16.0),)),
                  SizedBox(height: 50.0,),
                  Container(
                      child: Text('Deadline:- $deadline $deadlineTime',style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),)),
                  SizedBox(height: 20.0,),
                  assignmentupload ? SizedBox(
                      width: MediaQuery.of(context).size.width*0.9,
                      child: Text("$selectedfile",style: TextStyle(color: Colors.green),)): Text(''),
                  SizedBox(height: 20.0,),
                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: RaisedButton(onPressed: () async {
                      FilePickerResult result = await FilePicker.platform
                          .pickFiles(
                          type: FileType.custom, allowedExtensions: ['pdf']);
                      setState(() {
                        _object = result;
                        assignmentupload = true;
                        selectedfile = result.paths;
                      });
                    },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: assignmentupload ? Colors.green: Colors.blue[900],
                    child: Text(assignmentupload ?'File Selected': 'Select File',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  assignmentupload ? Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: RaisedButton(onPressed: () async {
                      if(_object ==null){
                         Fluttertoast.showToast(
                            msg: "Something went Wrong!!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                             textColor: Colors.green,
                             backgroundColor: Colors.grey);

                      }else{
                        FinalCall();
                        setState(() {
                          assignmentupload = false;
                        });
                      }
                    },
                      color: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text('Upload Assignment',style: TextStyle(color: Colors.white),),
                    ),
                  ):Text("")
                ],
              ),
            )
            ),
          ),
        ),
      ),
    );
  }
}
void savePdf(List<int> asset, String filename) async {
  StorageReference reference =
  FirebaseStorage.instance.ref().child("assignments");
  StorageUploadTask uploadTask = reference.putData(asset);
  String url = await (await uploadTask.onComplete).ref.getDownloadURL();
  if (url != null) {
    documentFileUpload(url);
  } else {
    Fluttertoast.showToast(
        msg: "Something went Wrong!!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.green,
        backgroundColor: Colors.grey);
    pd.hide();
  }
}

void documentFileUpload(String url) {
  Firestore.instance
      .collection(mailId)
      .document(subName)
      .collection("upload")
      .document(assignmentTitle)
      .setData({"Uploaded link": url,
    "score":"0"
  });
  Fluttertoast.showToast(
      msg: "Assignment Uploaded Successfully",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: Colors.black);
  pd.hide();
}
