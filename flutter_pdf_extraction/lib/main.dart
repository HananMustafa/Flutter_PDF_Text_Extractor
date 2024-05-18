import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Text Extractor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _selectedPdf; //This variable will store the device path of pdf
  String? _extractedText; //This variable will store extracted the text of pdf


  //PDF PICK METHOD
  Future<void> _pickPdf() async {
    //Open the file picker to select a PDF file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      //Get the selected file
      File file = File(result.files.single.path!);
      setState(() {
        _selectedPdf = file;
        _extractedText = null; // Clear previous extracted text
      });

      //Extract text from PDF
      await _extractTextFromPdf(file);
    } else {
      //User canceled the picker
      print('No file selected');
    }
  }

  //EXTRACTING TEXT FROM PDF METHOD
  Future<void> _extractTextFromPdf(File pdfFile) async {
    try {
      //Load the PDF document
      PdfDocument document = PdfDocument(
          inputBytes: pdfFile.readAsBytesSync());

      //Extract text from all the pages
      String text = PdfTextExtractor(document).extractText();

      //Dispose the document
      document.dispose();

      //Update the state with extracted text
      setState(() {
        _extractedText = text;
      });
    } catch (e) {
      //Handle any exceptions
      print('Error extracting text: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('PDF Text Extractor'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //Elevated Button
            ElevatedButton(
              onPressed: _pickPdf,
              child: Text('Upload PDF'),
            ),

            //Print Selected PDF file's path
            if (_selectedPdf != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Selected PDF: ${_selectedPdf!.path}'),
              ),

            //Print Extracted Text of PDF
            if (_extractedText != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: 300, //change as per your need
                  height: 300, //change as per your need
                  child: SingleChildScrollView(
                    child:Text('Extracted Text: $_extractedText'),
                  )
                )
              ),
          ],
        ),
      ),
    );
  }
}
