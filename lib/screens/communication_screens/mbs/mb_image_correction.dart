import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/image_correction_panel_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/image.dart';
import 'package:voce/widgets/close_line_top_modal.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';

class MbImageCorrection extends StatefulWidget {
  const MbImageCorrection({Key? key}) : super(key: key);

  @override
  State<MbImageCorrection> createState() => _MbImageCorrection();
}

class _MbImageCorrection extends State<MbImageCorrection> {
  late List<CaaImage> suggestedImageList;

  @override
  void initState() {
    super.initState();
    final cubit = BlocProvider.of<ImageCorrectionPanelCubit>(context);
    cubit.searchSuggestedImages();
  }

  Widget _buildLandscapeLayout() {
    Size media = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Column(
              children: [
                Center(child: CloseLineTopModal()),
                SizedBox(height: media.height * .05),
                Container(
                  child: ListTile(
                    title: Text(
                      'Correzione pittogramma',
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Puoi selezionare il nuovo pittogramma dalla lista dei pittogrammi suggeriti e sostituirlo',
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .015,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BlocBuilder<ImageCorrectionPanelCubit, ImageCorrectionPanelState>(
                builder: (context, state) {
                  if (state is ImageCorrectionPanelLoaded) {
                    return VocecaaPictogram(
                      caaImage: state.image,
                      widthFactor: .2,
                      heightFactor: .2,
                      fontSizeFactor: .018,
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              VerticalDivider(
                thickness: 3,
                color: Colors.black,
              ),
              SizedBox(
                height: media.height * .6,
                width: media.width * .6,
                child: BlocBuilder<ImageCorrectionPanelCubit,
                    ImageCorrectionPanelState>(
                  builder: (context, state) {
                    if (state is ImageCorrectionPanelLoaded) {
                      return SingleChildScrollView(
                        child: Container(
                          child: Wrap(
                            spacing: 7.0,
                            runSpacing: 7.0,
                            children: List.generate(
                              state.suggestedImages.length,
                              (index) => VocecaaPictogram(
                                caaImage: state.suggestedImages[index],
                                color: Color(0xffCCCCCC),
                                onTap: () {
                                  var cubit = BlocProvider.of<
                                      ImageCorrectionPanelCubit>(context);
                                  cubit.setNewImage(
                                      state.suggestedImages[index]);
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 150,
              padding: EdgeInsets.all(16),
              child: VocecaaButton(
                color: Color(0xFFFFE45E),
                text: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save),
                    SizedBox(width: 8.0),
                    Text(
                      'Salva',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  var cubit =
                      BlocProvider.of<ImageCorrectionPanelCubit>(context);
                  // TODO Modificare il controllo
                  // TODO Usare polimorfismo con Cubit su istanze diverse di Screen o finestre modali
                  if (cubit.caaTable != null) {
                    print("HELLO");
                    cubit.updateCsOutputImage();
                  }
                  Navigator.of(context).pop(cubit.getNewImage());
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPortraitLayout() {
    Size media = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: ListTile(
              title: Text(
                'Correzione pittogramma',
                style: GoogleFonts.poppins(
                  fontSize: media.height * .02,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Puoi selezionare il nuovo pittogramma dalla lista dei pittogrammi suggeriti e sostituirlo',
                style: GoogleFonts.poppins(
                  fontSize: media.height * .015,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          SizedBox(height: media.height * .02),
          BlocBuilder<ImageCorrectionPanelCubit, ImageCorrectionPanelState>(
            builder: (context, state) {
              if (state is ImageCorrectionPanelLoaded) {
                return VocecaaPictogram(
                  caaImage: state.image,
                  widthFactor: .3,
                  heightFactor: .3,
                  fontSizeFactor: .04,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Divider(
              thickness: 2,
              color: Colors.black45,
            ),
          ),
          SizedBox(
            height: media.height * .5,
            width: media.width * .75,
            child: BlocBuilder<ImageCorrectionPanelCubit,
                ImageCorrectionPanelState>(
              builder: (context, state) {
                if (state is ImageCorrectionPanelLoaded) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Numero di colonne
                      mainAxisSpacing: 10.0, // Spazio verticale tra le righe
                      crossAxisSpacing: 10.0,
                      childAspectRatio: media.width < 600
                          ? 6 / 5
                          : 7 / 3, // Spazio orizzontale tra le colonne
                    ),
                    itemCount: state.suggestedImages.length,
                    itemBuilder: (context, index) => VocecaaPictogram(
                      heightFactor: .25,
                      widthFactor: .25,
                      fontSizeFactor: .03,
                      caaImage: state.suggestedImages[index],
                      color: Color(0xffCCCCCC),
                      onTap: () {
                        var cubit =
                            BlocProvider.of<ImageCorrectionPanelCubit>(context);
                        cubit.setNewImage(state.suggestedImages[index]);
                      },
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                VocecaaButton(
                  color: Colors.transparent,
                  text: Text(
                    'Annulla',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: ConstantGraphics.colorPink,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
                VocecaaButton(
                  color: Color(0xFFFFE45E),
                  text: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.save),
                      SizedBox(width: 8.0),
                      Text(
                        'Salva',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    var cubit =
                        BlocProvider.of<ImageCorrectionPanelCubit>(context);
                    // TODO Modificare il controllo
                    // TODO Usare polimorfismo con Cubit su istanze diverse di Screen o finestre modali
                    if (cubit.caaTable != null) {
                      cubit.updateCsOutputImage();
                    }
                    Navigator.of(context).pop(cubit.getNewImage());
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildPortraitLayout();
          } else {
            return _buildLandscapeLayout();
          }
        },
      ),
    );
  }
}
