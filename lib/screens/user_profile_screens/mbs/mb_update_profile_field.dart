import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';

class MbUpdateProfileField extends StatefulWidget {
  const MbUpdateProfileField({
    Key? key,
    required this.title,
    this.initialValue,
    required this.textFieldLabel,
    this.isPasswordUpdate = false,
  }) : super(key: key);

  final String title;
  final String? initialValue;
  final String textFieldLabel;
  final bool isPasswordUpdate;

  @override
  State<MbUpdateProfileField> createState() => _MbUpdateProfileFieldState();
}

class _MbUpdateProfileFieldState extends State<MbUpdateProfileField> {
  String? textFieldValue;
  String textOldPassword = '';
  String textNewPasswordConfirm = '';

  @override
  void initState() {
    super.initState();
    widget.isPasswordUpdate
        ? textFieldValue = ""
        : textFieldValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    double textBaseSize =
        orientation == Orientation.landscape ? media.width : media.height;
    return Container(
      // height: media.height * .4,
      margin: EdgeInsets.fromLTRB(
        orientation == Orientation.landscape
            ? media.width * .25
            : media.width * .08,
        24,
        orientation == Orientation.landscape
            ? media.width * .25
            : media.width * .08,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      padding: EdgeInsets.all(22.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: textBaseSize * .018,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          if (widget.isPasswordUpdate)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: VocecaaTextField(
                onChanged: (value) {
                  setState(() {
                    textOldPassword = value;
                  });
                },
                label: "Inserisci la vecchia password",
                initialValue: textOldPassword,
              ),
            ),
          VocecaaTextField(
            onChanged: (value) {
              setState(() {
                textFieldValue = value;
              });
            },
            label: widget.textFieldLabel,
            initialValue: textFieldValue!,
          ),
          if (widget.isPasswordUpdate)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: VocecaaTextField(
                onChanged: (value) {
                  setState(() {
                    textNewPasswordConfirm = value;
                  });
                },
                label: "Conferma la nuova password",
                initialValue: textOldPassword,
              ),
            ),
          SizedBox(height: 10),
          VocecaaButton(
            color: ConstantGraphics.colorYellow,
            text: AutoSizeText(
              'Salva',
              style: GoogleFonts.poppins(
                fontSize: textBaseSize * .018,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              if (widget.isPasswordUpdate) {
                if (textFieldValue!.compareTo(textNewPasswordConfirm) != 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        // use this to update the content of the AlertDialog
                        builder: (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            title: Text('Errore nella modifica della password'),
                            content: Text("Le due password non coincidono"),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'Ho capito',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() => Navigator.pop(context));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                } else if (textOldPassword.isEmpty ||
                    textNewPasswordConfirm.isEmpty ||
                    textFieldValue!.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        // use this to update the content of the AlertDialog
                        builder: (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            title: Text('Errore nella modifica della password'),
                            content: Text("Devi compilare tutti i campi"),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'Ho capito',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() => Navigator.pop(context));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                } else {
                  Navigator.pop(context, [textOldPassword, textFieldValue]);
                }
              } else {
                Navigator.pop(context, [textFieldValue]);
              }
            },
          ),
          VocecaaButton(
            color: Colors.transparent,
            text: AutoSizeText(
              'Annulla',
              style: GoogleFonts.poppins(
                fontSize: textBaseSize * .018,
                fontWeight: FontWeight.bold,
                color: ConstantGraphics.colorPink,
              ),
            ),
            onTap: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
