import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class ShowPdf extends StatefulWidget {
  final String value;
  final String title;
  ShowPdf({this.value, this.title});
  @override
  _ShowPdfState createState() => _ShowPdfState(value, title);
}

class _ShowPdfState extends State<ShowPdf> {
  final String value;
  final String title;

  _ShowPdfState(this.value, this.title);

  // String pdfasset="assets/cse/csesecond.pdf";
  PDFDocument _doc;
  bool _loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPdf();
  }

  _initPdf() async {
    setState(() {
      _loading = true;
    });
    //final doc = await PDFDocument.fromURL(url);

    final doc = await PDFDocument.fromURL(value.toString());

    setState(() {
      _doc = doc;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          :
          //checkmethod();
          PDFViewer(
              document: _doc,
            ),
    );
  }
}
