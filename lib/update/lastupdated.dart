import 'package:cloud_firestore/cloud_firestore.dart';

void lastupdated(teacherid,classname)async{
  DateTime currentPhoneDate = DateTime.now(); //DateTime

  Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate); //To TimeStamp

  await Firestore.instance.collection(teacherid).doc(classname).updateData({
    'last_updated': myTimeStamp
  });
}