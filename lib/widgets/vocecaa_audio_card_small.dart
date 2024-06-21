import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VocecaaAudioCardSmall extends StatelessWidget {
  const VocecaaAudioCardSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      width: media.width * .26,
      height: media.height * .06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(
          width: 1,
          color: Colors.black45,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: media.width * .04,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(15)),
              color: Colors.grey[400],
            ),
            child: Center(
              child: Icon(
                Icons.mic,
                size: media.width * .02,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(8.0, 2.0, 0, 0),
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Nome traccia audio con nome riferimento\n',
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
              width: media.width * .04,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(15)),
                color: Theme.of(context).primaryColor,
              ),
              child: Center(
                child: Icon(
                  Icons.play_circle_outline_outlined,
                  size: media.width * .02,
                ),
              ))
        ],
      ),
    );
  }
}
