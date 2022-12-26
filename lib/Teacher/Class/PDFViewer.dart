import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
class ShowPdf extends StatefulWidget {
  final value;
  ShowPdf({this.value});
  @override
  _ShowPdfState createState() => _ShowPdfState(value);
}

class _ShowPdfState extends State<ShowPdf> {
  final value;

  _ShowPdfState(this.value);

  // String pdfasset="assets/cse/csesecond.pdf";
  // ignore: file_names
  PDFDocument _doc;
  bool _loading = false;

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
        title: Text('PDF Viewer', style: TextStyle(fontStyle: FontStyle.italic),),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: _loading ? Center(child: CircularProgressIndicator(),) :
      //checkmethod();
      PDFViewer(document: _doc,
      ),
    );
  }
}