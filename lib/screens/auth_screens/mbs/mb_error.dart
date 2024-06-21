import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MbError extends StatefulWidget {
  const MbError({
    Key? key,
    required this.title,
    required this.subtitle,
    this.heightFactor = .6,
    this.animationUrl =
        'https://assets7.lottiefiles.com/packages/lf20_imrP4H.json',
    this.bottomWidgets = const [],
  }) : super(key: key);

  final String title;
  final String subtitle;
  final double heightFactor;
  final String animationUrl;
  final List<Widget> bottomWidgets;

  @override
  _MbErrorState createState() => _MbErrorState();
}

class _MbErrorState extends State<MbError> with TickerProviderStateMixin {
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
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        height: media.height * widget.heightFactor,
        width: isLandscape ? media.width * .4 : media.width * .8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Color(0xffF9F9F9),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
                  Container(
                    child: Text(
                      'Attenzione!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize:
                            isLandscape ? media.width * .03 : media.height * .03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    child: Lottie.network(
                      widget.animationUrl,
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
                          fontSize: isLandscape
                              ? media.width * .02
                              : media.height * .03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        widget.subtitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .019,
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
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Text(
                        'Ho capito',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: isLandscape
                                ? media.width * .015
                                : media.height * .019,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ] +
                widget.bottomWidgets,
          ),
        ),
      ),
    );
  }
}
