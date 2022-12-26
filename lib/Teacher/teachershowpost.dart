import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'file:///D:/myflutterprojects/studyics/lib/StudentOnly/studentsocialmedia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyivs/Teacher/Class/submmittedassignment.dart';
import 'package:studyivs/Teacher/socialmedia.dart';
import 'package:studyivs/UI/socialmediacard.dart';
bool _isliked = false;
String name,email,imageurl;
class TeacherShowPost extends StatefulWidget {
  @override
  _TeacherShowPostState createState() => _TeacherShowPostState();
}

class _TeacherShowPostState extends State<TeacherShowPost> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getdata();
  }
  @override
  _getdata()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("teachervalue");
    });
  }
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Posts'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Icon(
                Icons.add_box,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                //Navigator.push(context, new MaterialPageRoute(builder: (context) => new TeacherSocialMedia(teacherid: name,)));
              },
            ),
          )
        ],
      ),
      body: (GetPost()),
    );
  }
}

class GetPost extends StatefulWidget {
  @override
  _GetPostState createState() => _GetPostState();
}

class _GetPostState extends State<GetPost> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance.collection("Posts").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return Center(child: new CircularProgressIndicator());
          return Container(
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 15.0),
            child: new ListView(
              // ignore: deprecated_member_use
              children: snapshot.data.documents.map((document){
                final String caption = document['caption'];
                String linkimg = document['image_url'];
                String nameis = document['name'];
                String numberoflike= document['likenumber'];
                String upload = document['uploaded'];
                String docsid = document.id;
                bool isliked = false;
                bool is_image = document['is_image'];
                return new  SocialCard(uploader: upload,name: nameis,captions: caption,linkimage: linkimg,is_images: is_image,);
              }).toList(),
            ),
          );
        }
    );
  }
}