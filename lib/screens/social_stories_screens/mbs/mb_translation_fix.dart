import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/image.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_pictogram_selectable.dart';

class MbTranslationFix extends StatefulWidget {
  const MbTranslationFix({
    Key? key,
    required this.imageCorrectionList,
  }) : super(key: key);

  final Map<String, List<CaaImage>> imageCorrectionList;

  @override
  State<MbTranslationFix> createState() => _MbTranslationFixState();
}

class _MbTranslationFixState extends State<MbTranslationFix> {
  Map<String, CaaImage> imagesSelected = {};

  bool isImageSelected(CaaImage image, String keyLabel) {
    if (imagesSelected.containsKey(keyLabel)) {
      return imagesSelected[keyLabel]!.id == image.id;
    } else {
      return false;
    }
  }

  void setImageSelected(bool value, CaaImage image, String keyLabel) {
    if (value) {
      setState(() {
        imagesSelected.update(
          keyLabel,
          (value) => image,
          ifAbsent: () => image,
        );
      });
    } else {
      setState(() {
        imagesSelected.remove(keyLabel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: Container(
          margin: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            0 + MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .018,
                    color: Colors.black87,
                  ),
                  children: [
                    TextSpan(
                        text: "C'è stato un problema nella traduzione\n",
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            "Non sono state trovate alcune immagini durante il processo di traduzione. Potrai comunque selezionarle tra quelle proposte per completare la frase:")
                  ],
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverList.builder(
                      itemCount: widget.imageCorrectionList.length,
                      itemBuilder: (context, sliverIndex) {
                        var key = widget.imageCorrectionList.keys
                            .toList()[sliverIndex];
                        List<CaaImage>? imageList =
                            widget.imageCorrectionList[key];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  fontSize: isLandscape
                                      ? media.width * .015
                                      : media.height * .02,
                                  color: Colors.black87,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Pittogrammi trovati per la parola ",
                                  ),
                                  TextSpan(
                                    text: "$key",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            SizedBox(
                              height: media.height * .13,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) =>
                                    VocecaaPictogramSelectable(
                                  caaImage: imageList![index],
                                  widthFactor: isLandscape ? .11 : .25,
                                  heightFactor: isLandscape ? .08 : .2,
                                  fontSizeFactor: isLandscape ? .014 : .03,
                                  onTap: (value) {
                                    setImageSelected(
                                        value, imageList[index], key);
                                  },
                                  isSelected:
                                      isImageSelected(imageList[index], key),
                                ),
                                separatorBuilder: (_, __) =>
                                    SizedBox(width: 10),
                                itemCount: imageList!.length,
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        );
                      }, // add builder
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  VocecaaButton(
                    color: ConstantGraphics.colorPink,
                    text: AutoSizeText(
                      'Annulla Correzione',
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: isLandscape
                            ? media.width * .015
                            : media.height * .018,
                      ),
                    ),
                    onTap: () {
                      imagesSelected.clear();
                      Navigator.pop(context, imagesSelected);
                    },
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    child: VocecaaButton(
                      color: ConstantGraphics.colorYellow,
                      text: Text(
                        'Correggi',
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .018,
                        ),
                      ),
                      onTap: () {
                        if (imagesSelected.keys.length ==
                            widget.imageCorrectionList.keys.length) {
                          Navigator.pop(context, imagesSelected);
                        } else {
                          final snackBar = SnackBar(
                            backgroundColor: ConstantGraphics.colorYellow,
                            showCloseIcon: true,
                            content: Text(
                              'Devi selezionare un immagine per tutte le parole per poter procedere alla correzione',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
