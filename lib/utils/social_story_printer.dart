import 'dart:convert';

import 'package:voce/models/image.dart';
import 'package:voce/models/social_story.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrinterSocialStory {
  SocialStory socialStory;
  Map<String, List<List<CaaImage>>> imageMap = {};

  PrinterSocialStory(this.socialStory) {
    for (var i = 0; i < socialStory.comunicativeSessionList.length; i++) {
      imageMap[socialStory.comunicativeSessionList[i].title] = [];

      for (var j = 0;
          j < socialStory.comunicativeSessionList[i].imageList.length;
          j++) {
        if (j % 6 == 0) {
          imageMap[socialStory.comunicativeSessionList[i].title]!.add([]);
        }
        imageMap[socialStory.comunicativeSessionList[i].title]![
                imageMap[socialStory.comunicativeSessionList[i].title]!.length -
                    1]
            .add(socialStory.comunicativeSessionList[i].imageList[j]);
      }
    }
  }

  pw.Header header() {
    return pw.Header(
      level: 0,
      child: pw.Text(socialStory.title,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          )),
    );
  }

  pw.Container phrase(String title, List<List<CaaImage>> imageList) {
    return pw.Container(
      margin: pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        children: [
          pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              title,
              textAlign: pw.TextAlign.left,
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Column(
              children: List.generate(
            imageList.length,
            (rowIndex) => pw.Row(
              children: List.generate(
                imageList[rowIndex].length,
                (imageIndex) => pw.Container(
                  height: 75,
                  width: 75,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: PdfColor.fromHex('#000000'),
                      width: 1,
                    ),
                  ),
                  margin: pw.EdgeInsets.only(right: 10, bottom: 15),
                  child: pw.Image(
                    pw.MemoryImage(
                      base64Decode(
                        imageList[rowIndex][imageIndex].stringCoding.substring(
                            2,
                            imageList[rowIndex][imageIndex]
                                    .stringCoding
                                    .length -
                                1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  pw.Column _build({
    bool firstPage = false,
    required Map<String, List<List<CaaImage>>> phrases,
  }) {
    List<pw.Widget> components = [];
    if (firstPage) components.add(header());

    phrases.forEach((key, value) {
      components.add(
        pw.Positioned(
            top: 150,
            child: phrase(
              key,
              value,
            )),
      );
    });
    return pw.Column(children: components);
  }

  Future<void> printDoc() async {
    final doc = pw.Document();

    List<Map<String, List<List<CaaImage>>>> subMaps = [];
    Map<String, List<List<CaaImage>>> subMap = {};
    int rowCount = 0;

    imageMap.forEach((key, value) {
      int rowsForCurrentPhrase = (value.length % 6).truncate();
      rowCount += rowsForCurrentPhrase;

      if (rowCount > 5 && subMap.isNotEmpty) {
        subMaps.add(subMap);
        subMap = {};
        rowCount =
            rowsForCurrentPhrase; // reset rowCount to the rows for the current phrase
      }

      subMap[key] = value; // add the current phrase to the subMap
    });

// Add remaining items to subMaps
    if (subMap.isNotEmpty) {
      subMaps.add(subMap);
    }

// Create pages for each subMap
    for (var i = 0; i < subMaps.length; i++) {
      doc.addPage(
        pw.Page(
          build: (pw.Context context) => _build(
            phrases: subMaps[i],
            firstPage: i == 0,
          ),
        ),
      );
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  Future<void> deleteDoc() async {}
}
