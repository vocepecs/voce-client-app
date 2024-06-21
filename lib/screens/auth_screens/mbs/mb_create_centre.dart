import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/add_autism_centre_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/close_line_top_modal.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';

class MbCreateCentre extends StatelessWidget {
  const MbCreateCentre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    double textBaseSize =
        orientation == Orientation.landscape ? media.width : media.height;
    return Container(
      width: media.width * .3,
      padding: orientation == Orientation.landscape
          ? EdgeInsets.fromLTRB(
              15,
              8,
              15,
              MediaQuery.of(context).viewInsets.bottom + 8,
            )
          : EdgeInsets.fromLTRB(
              15, 8, 15, MediaQuery.of(context).viewInsets.bottom + 30),
      margin: orientation == Orientation.landscape
          ? EdgeInsets.fromLTRB(
              media.width * .25,
              0,
              media.width * .25,
              20,
            )
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: CloseLineTopModal()),
          ListTile(
            title: Text(
              'Crea un nuovo centro',
              style: GoogleFonts.poppins(
                fontSize: textBaseSize * .02,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Inserisci nome e indirizzo del centro. Conferma per creare un nuovo centro e ricevere il suo codice segreto',
              style: GoogleFonts.poppins(
                fontSize: textBaseSize * .016,
              ),
            ),
          ),
          SizedBox(height: 15.0),
          orientation == Orientation.portrait
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        width: media.width * .7,
                        height: media.height * .06,
                        child: VocecaaTextField(
                          onChanged: (value) {
                            final cubit =
                                BlocProvider.of<AddAutismCentreCubit>(context);
                            cubit.updateAutismCentreName(value);
                          },
                          label: 'Nome',
                          initialValue: '',
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      width: media.width * .7,
                      height: media.height * .06,
                      child: VocecaaTextField(
                        onChanged: (value) {
                          final cubit =
                              BlocProvider.of<AddAutismCentreCubit>(context);
                          cubit.updateAutismCentreAddress(value);
                        },
                        label: 'Indirizzo',
                        initialValue: '',
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: media.width * .2,
                      height: media.height * .06,
                      child: VocecaaTextField(
                        onChanged: (value) {
                          final cubit =
                              BlocProvider.of<AddAutismCentreCubit>(context);
                          cubit.updateAutismCentreName(value);
                        },
                        label: 'Nome',
                        initialValue: '',
                      ),
                    ),
                    SizedBox(
                      width: media.width * .2,
                      height: media.height * .06,
                      child: VocecaaTextField(
                        onChanged: (value) {
                          final cubit =
                              BlocProvider.of<AddAutismCentreCubit>(context);
                          cubit.updateAutismCentreAddress(value);
                        },
                        label: 'Indirizzo',
                        initialValue: '',
                      ),
                    ),
                  ],
                ),
          SizedBox(height: 15.0),
          Center(
            child: BlocBuilder<AddAutismCentreCubit, AddAutismCentreState>(
              builder: (context, state) {
                if (state is AutismCentreCreated) {
                  return SizedBox(
                    width: orientation == Orientation.landscape ? media.width * .3 : media.width * .7,
                    height: media.height * .2,
                    child: ListTile(
                      title: Text(
                        state.secretCode,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: textBaseSize * .03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Questo è il tuo codice segreto, comunicalo solamente agli operatori del centro!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: textBaseSize * .018,
                        ),
                      ),
                    ),
                  );
                } else if (state is AddAutismCentreLoading) {
                  return SizedBox(
                    width: media.width * .3,
                    height: media.height * .2,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 10,
                    width: 10,
                  );
                }
              },
            ),
          ),
          SizedBox(height: 15.0),
          BlocBuilder<AddAutismCentreCubit, AddAutismCentreState>(
            builder: (context, state) {
              return VocecaaButton(
                color: ConstantGraphics.colorYellow,
                text: Text(
                  state is AutismCentreCreated
                      ? 'Conferma e chiudi'
                      : 'Crea centro',
                  style: GoogleFonts.poppins(
                    fontSize: orientation == Orientation.landscape ? textBaseSize * .014 : textBaseSize * .018,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  if (state is AutismCentreCreated) {
                    Navigator.pop(context);
                  } else {
                    var cubit = BlocProvider.of<AddAutismCentreCubit>(context);
                    cubit.createAutismCentre();
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }
}
