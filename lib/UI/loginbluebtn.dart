import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class LoginBlueBtn extends StatelessWidget {
  TextEditingController emailcntr,passwordcntr;
  Function function;
  String buttontitle;
  LoginBlueBtn({required this.emailcntr,required this.passwordcntr,required this.function(),required this.buttontitle});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.7,
      height: 50,
      child: RaisedButton(
        onPressed: (){
          if(emailcntr.text.toString()!=null){
            if(passwordcntr.text.toString()!=null){
              function();
            }else{
              Fluttertoast.showToast(
                  msg: "Password is required",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.red,
                  backgroundColor: Colors.white
              );
            }
          }else{
            Fluttertoast.showToast(
                msg: "Email is required",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                textColor: Colors.red,
                backgroundColor: Colors.white
            );
          }
        },
        child: Text(buttontitle,style: TextStyle(color: Colors.white),),
        color: Colors.blue[900],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0)
        ),
      ),
    );
  }
}
