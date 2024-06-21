import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MbsAnimationAlert extends StatefulWidget {
  const MbsAnimationAlert({
    Key? key,
    required this.title,
    required this.subtitle,
    this.animationPath = 'assets/anim_confirm.json',
    this.lottieFromNetwork = false,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String animationPath;
  final bool lottieFromNetwork;

  @override
  _MbsAnimationAlertState createState() => _MbsAnimationAlertState();
}

class _MbsAnimationAlertState extends State<MbsAnimationAlert>
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    bool isLandscape = orientation == Orientation.landscape;

    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        height: media.height * .6,
        width: isLandscape ? media.width * .4 : media.width * .8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Color(0xffF9F9F9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: media.height * .2,
              height: media.height * .2,
              child: widget.lottieFromNetwork
                  ? Lottie.network(
                      widget.animationPath,
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller
                          ..duration = composition.duration
                          ..forward();
                      },
                    )
                  : Lottie.asset(
                      widget.animationPath,
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller
                          ..duration = composition.duration
                          ..forward();
                      },
                    ),
            ),
            Container(
              child: ListTile(
                title: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: isLandscape ? media.width * .02 : media.height * .03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: isLandscape ? media.width * .015 : media.height * .019,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .08),
                decoration: BoxDecoration(
                    color: Color(0xffffe45e),
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Text(
                  'Ho capito',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: Colors.black87,
                      fontSize: isLandscape ? media.width * .015 : media.height * .019,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
