import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BlueButton extends StatelessWidget {
  String buttontitle;
  Function _func;
  TextEditingController email;
  TextEditingController pass;
  BlueButton(this.buttontitle, this._func, this.email, this.pass);
  gettoast(message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        textColor: Colors.white,
        backgroundColor: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: RaisedButton(
        onPressed: () async {
          if (email.text.toString() == null) {
            if (pass.text.toString() == null) {
              gettoast("Password Mandatory");
            } else {
              _func();
            }
          } else {
            gettoast("Username is Mandatory");
          }
        },
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Text(
          buttontitle,
          style: TextStyle(color: Colors.blue[900]),
        ),
      ),
    );
  }
}
