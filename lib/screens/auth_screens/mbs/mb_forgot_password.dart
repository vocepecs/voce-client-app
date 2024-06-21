import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class VoceModalForgotPassword extends StatefulWidget {
  const VoceModalForgotPassword({Key? key}) : super(key: key);

  @override
  State<VoceModalForgotPassword> createState() =>
      _VoceModalForgotPasswordState();
}

class _VoceModalForgotPasswordState extends State<VoceModalForgotPassword> {
  String email = '';

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        32 + MediaQuery.of(context).viewInsets.bottom,
      ),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Recupera password',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Inserisci la tua email per ricevere una password temporanea.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: VocecaaButton(
                  color: Colors.transparent,
                  text: Text(
                    'Annulla',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ConstantGraphics.colorPink,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                      context,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: VocecaaButton(
                  color: ConstantGraphics.colorYellow,
                  text: SizedBox(
                    width: media.width * 0.2,
                    child: Center(
                      child: Text(
                        'Invia',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                      context,
                      email.trim(),
                    );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
