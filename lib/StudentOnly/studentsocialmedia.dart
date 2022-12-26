import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:progress_dialog/progress_dialog.dart';
ProgressDialog pd;
String imagename;
String teachername;
String sharepoststr;
bool _imagepicked = false;

class SocialMedia extends StatefulWidget {
  String email,name,imageurl;

  //String name,email,imageurl;
  SocialMedia({this.name,this.email,this.imageurl});
  @override
  _SocialMediaState createState() => _SocialMediaState(name,email,imageurl);
}

class _SocialMediaState extends State<SocialMedia> {
  String name,email,imageurl;
  _SocialMediaState(this.name,this.email,this.imageurl);

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 15);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print("this is image path  $_image");
      } else {
        print('No image selected.');
      }
    });
  }

  Future getCImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 15);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print("this is image path  $_image");
      } else {
        print('No image selected.');
      }
    });
  }

  TextEditingController captioncontroller = new TextEditingController();
  TextEditingController postcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context, type: ProgressDialogType.Normal);
    return Scaffold(
        appBar: AppBar(
          title: Text('Share Post'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 35.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100.0,
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.8,
                        child: TextField(
                          maxLines: 10,
                          decoration: InputDecoration(
                            labelText: "Share Post",
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.blue[900])
                            ),
                          ),
                          controller: postcontroller,
                          onChanged: (text){
                            sharepoststr = postcontroller.text.toString();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: FlatButton(onPressed: (){
                    share(email);
                  },child: Text('Post',style: TextStyle(color: Colors.white),),
                    color: Colors.blue[900],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(30.0),
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Enter Caption"
                    ),
                    controller: captioncontroller,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        getImage();
                      },
                      child: InkWell(
                        onTap: getImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 100.0,
                          child: CircleAvatar(
                            radius: 100.0,
                            child: ClipOval(
                                child : _image!=null ? Image.file(_image):Image.network("https://cdn1.iconfinder.com/data/icons/rounded-black-basic-ui/139/Gallery-RoundedBlack-512.png")
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0,),
                    GestureDetector(
                      onTap: (){
                        getCImage();
                      },
                      child: InkWell(
                        onTap: getCImage,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 100.0,
                          child: CircleAvatar(
                            radius: 100.0,
                            child: ClipOval(
                              child: _image!=null? Image.file(_image):Image.network("https://cdn1.iconfinder.com/data/icons/black-round-web-icons/100/round-web-icons-black-07-512.png"),
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top: 18.0),
                  child: Text('Click on icon to select your photo', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                ),
                SizedBox(height: 20.0,),
                Container(
                  width: MediaQuery.of(context).size.width*0.8,
                  padding: EdgeInsets.only(top: 35),
                  child: RaisedButton(
                    onPressed: (){
                      sharepost(email);
                    },
                    child: Text('Share Post',style: TextStyle(color: Colors.white),),
                    color: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
  share(String teacherid)async{
    var rng  = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }
    pd.show();
    pd.update(message: "Share Post");
    if(sharepoststr!=null){
      await FirebaseFirestore.instance.collection("Posts").document(randomName)
          .setData({
        'image_url': sharepoststr,
        'caption': "",
        'name': name,
        'likenumber':"0",
        'randomName': randomName,
        'is_image': false,
        'uploaded':imageurl
      });
      await FirebaseFirestore.instance.collection("Profilestudyic").document("Profilestudyic").collection(email).document(randomName)
          .setData({
        'image_url': sharepoststr,
        'caption': "",
        'name': name,
        'uploaded': imageurl,
        'likenumber':"0",
        'is_image': false,
        'randomName': randomName
      });
      postcontroller.clear();
      Fluttertoast.showToast(
          msg: "Post uploaded successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.green,
          backgroundColor: Colors.white
      );
      pd.hide();
    }else{
      Fluttertoast.showToast(
          msg: "Please enter some text",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.green,
          backgroundColor: Colors.white
      );
      pd.hide();
    }
  }
  void sharepost(String email) async{

    var rng  = new Random();
    String randomName="";
    for (var i = 0; i < 20; i++) {
      randomName += rng.nextInt(100).toString();
    }
    if(_image!=null){
      pd.show();
      pd.update(message: "Uploading Post..");

      final String caption = captioncontroller.text.toString();
      StorageReference ref = FirebaseStorage.instance.ref();
      StorageTaskSnapshot addImg = await ref.child("image/$randomName").putFile(_image).onComplete;


      if(addImg.error == null){
        final String downloadUrl = await addImg.ref.getDownloadURL();
        await FirebaseFirestore.instance.collection("Posts").document(randomName)
            .setData({
          'image_url': downloadUrl,
          'caption': caption,
          'name': name,
          'uploaded': imageurl,
          'likenumber':"0",
          'randomName': randomName,
          'is_image': true,
        });

        await FirebaseFirestore.instance.collection("Profilestudyic").document("Profilestudyic").collection(email).document(randomName)
            .setData({
          'image_url': downloadUrl,
          'caption': caption,
          'name': name,
          'uploaded': imageurl,
          'likenumber':"0",
          'randomName': randomName,
          'is_image': true
        });
        captioncontroller.clear();

        Fluttertoast.showToast(
            msg: "Post uploaded successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.green,
            backgroundColor: Colors.white
        );
        pd.hide();
      }else{
        Fluttertoast.showToast(
            msg: "Post uploading failed please try again..",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.green,
            backgroundColor: Colors.white
        );
        pd.hide();
      }
    }else{
      Fluttertoast.showToast(
          msg: "Post uploading failed please try again..",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.green,
          backgroundColor: Colors.white
      );
      pd.hide();
    }
  }

}
