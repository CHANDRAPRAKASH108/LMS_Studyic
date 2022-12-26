import 'package:cloud_FirebaseFirestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class ShowSubmission extends StatefulWidget {
  String url;
  ShowSubmission({this.url});
  @override
  _ShowSubmissionState createState() => _ShowSubmissionState(url);
}

class _ShowSubmissionState extends State<ShowSubmission> {
  String url;
  _ShowSubmissionState(this.url);
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

    final doc = await PDFDocument.fromURL(url);

    setState(() {
      _doc = doc;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Submission'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
      body: (
      _loading ? Center(
        child: CircularProgressIndicator(),
      )
          :
      PDFViewer(
        document: _doc,
      )
      ),
    );
  }
}

