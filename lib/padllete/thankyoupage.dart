import 'package:flutter/material.dart';

class Thankyoupage extends StatefulWidget {
  @override
  _ThankyoupageState createState() => _ThankyoupageState();
}

class _ThankyoupageState extends State<Thankyoupage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: NetworkImage(
        "https://www.worcesterconservatives.org.uk/sites/www.worcesterconservatives.org.uk/files/2019-05/thanksforvoting.jpg"),
    fit: BoxFit.fill,
    ),
    ),
    )
    );
  }
}
