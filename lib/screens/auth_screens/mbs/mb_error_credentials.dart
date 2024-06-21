import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class MbCredentialsError extends StatefulWidget {
  const MbCredentialsError({Key? key}) : super(key: key);

  @override
  _MbCredentialsErrorState createState() => _MbCredentialsErrorState();
}

class _MbCredentialsErrorState extends State<MbCredentialsError>
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
    return Center(
      child: Container(
        padding: EdgeInsets.all(15),
        height: media.height * .6,
        width: media.width * .4,
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
              child: Text(
                'Attenzione!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: media.width * .03,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 200,
              height: 200,
              child: Lottie.network(
                'https://assets7.lottiefiles.com/packages/lf20_imrP4H.json',
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ),
            Container(
              child: Text(
                'Username o password errati',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: media.width * .02,
                  fontWeight: FontWeight.bold,
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
                      fontSize: media.width * .015,
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
