import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:voce/models/comunicative_session.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';

class PrintScreen extends StatefulWidget {
  const PrintScreen({
    Key? key,
    required this.imageList,
    required this.socialStory,
  }) : super(key: key);

  final List<Uint8List> imageList;
  final SocialStory socialStory;

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inspect(widget.imageList);
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios_outlined,
            size: media.width * .015,
            color: Colors.black,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Anteprima',
              style: TextStyle(
                fontSize: media.width * 0.015,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0330AB),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: media.height * .08),
        child: PdfPreview(
          allowSharing: false,
          useActions: true,
          scrollViewDecoration: BoxDecoration(color: Colors.white),
          build: (format) => _generatePDF(format),
        ),
      ),
    );
  }

  Widget _buildContainer(int index, BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      height: media.height * .2,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.socialStory.comunicativeSessionList[index].title,
              style: GoogleFonts.poppins(
                fontSize: media.width * .013,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: media.height * .12,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, imageIndex) => VocecaaPictogram(
                  caaImage: widget.socialStory.comunicativeSessionList[index]
                      .imageList[imageIndex],
                  isErasable: false,
                  color: Theme.of(context).primaryColor,
                ),
                separatorBuilder: (_, __) => SizedBox(
                  width: 10,
                ),
                itemCount: widget.socialStory.comunicativeSessionList[index]
                    .imageList.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Uint8List> _generatePDF(PdfPageFormat format) {
    final pdf = pw.Document();

    //get qr image to print
    final socialStoryImage = pw.MemoryImage(widget.imageList[0]);

    //custom page format
    final width = 120 * PdfPageFormat.mm;
    final height = 78 * PdfPageFormat.mm;
    final margin = 0 * PdfPageFormat.mm;

    List<ComunicativeSession> csList =
        widget.socialStory.comunicativeSessionList;

    List<List<ComunicativeSession>> pdfCsList = List.empty(growable: true);
    int page = 0;
    List<ComunicativeSession> tmpCsList = List.empty(growable: true);
    print(csList.length);
    for (var i = 0; i < csList.length; i++) {
      if (i % 4 == 0) {
        pdfCsList.add(tmpCsList);
        page++;
        tmpCsList.clear();
      } else {
        tmpCsList.add(csList[i]);
      }
    }

    pdfCsList.forEach((element) {
      print(element.length);
      pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat(width, height, marginAll: margin),
        build: (pw.Context context) => pw.ListView(
          children: List.generate(
            element.length,
            (index) => pw.Container(
                height: 20,
                width: 20,
                margin: pw.EdgeInsets.all(10.0 * index),
                color: PdfColor.fromHex('000000')),
          ),
        ),
      ));
    });

    // pdf.addPage(
    //   pw.Page(
    //     pageFormat: PdfPageFormat(width, height, marginAll: margin),
    //     build: (pw.Context context) {
    //       return pw.Center(
    //         child: pw.ListView(
    //           children: List.generate(
    //             widget.socialStory.comunicativeSessionList.length,
    //             (index) => pw.Container(
    //                 height: 20,
    //                 width: 20,
    //                 margin: pw.EdgeInsets.all(10),
    //                 color: PdfColor.fromHex('000000')),
    //           ),
    //         ),
    //       ); // Center
    //     },
    //   ),
    // );

    return pdf.save();
  }
}
