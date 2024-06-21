import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/constants/constant_graphics.dart';

class ModalDeleteAccount extends StatelessWidget {
  const ModalDeleteAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    Size screenSize = media.size;
    bool isLandscape = media.orientation == Orientation.landscape;
    return Container(
      margin: EdgeInsets.fromLTRB(
        isLandscape ? screenSize.width * .25 : screenSize.width * .05,
        10,
        isLandscape ? screenSize.width * .25 : screenSize.width * .05,
        10,
      ),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isLandscape
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.asset("assets/icons/icon_info.png", height: 50),
              ),
              Center(
                child: Text(
                  "Eliminazione account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isLandscape
                        ? screenSize.width * .02
                        : screenSize.height * .03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Ti verrà inviata una email di conferma per poter eliminare il tuo account.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isLandscape
                      ? screenSize.width * .02
                      : screenSize.height * .03,
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Annulla",
                      style: GoogleFonts.poppins(
                        color: ConstantGraphics.colorPink,
                        fontSize: isLandscape
                            ? screenSize.width * .015
                            : screenSize.height * .02,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      "Conferma",
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: isLandscape
                            ? screenSize.width * .015
                            : screenSize.height * .02,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstantGraphics.colorYellow,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
