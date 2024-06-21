import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class VoceModalConfirm extends StatefulWidget {
  const VoceModalConfirm({
    Key? key,
    required this.title,
    required this.subtitle,
    this.animationPath = 'assets/anim_confirm.json',
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String animationPath;

  @override
  State<VoceModalConfirm> createState() => _VoceModalConfirmState();
}

class _VoceModalConfirmState extends State<VoceModalConfirm>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.fromLTRB(
        isLandscape ? media.width * .2 : 8,
        8,
        isLandscape ? media.width * .2 : 8,
        8,
      ),
      height: media.height * .6,
      // width: isLandscape ? media.width * .4 : media.width * .8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Color(0xffF9F9F9),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: media.height * .2,
            height: media.height * .2,
            child: Lottie.asset(
              widget.animationPath,
              controller: _controller,
              onLoaded: (composition) {
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
            ),
          ),
          AutoSizeText(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .02 : media.height * .04,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          AutoSizeText(
            widget.subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
              color: Colors.black87,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              VocecaaButton(
                color: Colors.transparent,
                text: AutoSizeText(
                  'Annulla',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: ConstantGraphics.colorPink,
                      fontSize: isLandscape
                          ? media.width * .015
                          : media.height * .02),
                ),
                onTap: () => Navigator.pop(context, false),
              ),
              VocecaaButton(
                color: ConstantGraphics.colorYellow,
                text: AutoSizeText(
                  'Conferma',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: isLandscape
                          ? media.width * .015
                          : media.height * .02),
                ),
                onTap: () => Navigator.pop(context, true),
              )
            ],
          )
        ],
      ),
    );
  }
}
