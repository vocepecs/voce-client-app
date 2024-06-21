import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/dedicated_cubits/search_voce_images_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/close_line_top_modal.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_pictogram_simple.dart';
import 'package:voce/widgets/vocecaa_searchbar.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';

class VocecaaMbSearchImage extends StatelessWidget {
  const VocecaaMbSearchImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<SearchVoceImagesCubit>(context);
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      height: media.height * .65,
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 8),
      margin: EdgeInsets.fromLTRB(
        isLandscape ? media.width * .25 : 8,
        0,
        isLandscape ? media.width * .25 : 8,
        isLandscape ? media.height * .1 : 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Column(
        children: [
          CloseLineTopModal(),
          Spacer(),
          AutoSizeText(
            'Cerca un\'immagine nel database VOCE',
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .016 : media.height * .018,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Row(
            children: [
              Expanded(
                flex: 10,
                child: VocecaaTextField(
                  onChanged: (value) => cubit.searchText = value,
                  label: 'Cerca immagini',
                  initialValue: '',
                ),
              ),
              // Spacer(),
              // SizedBox(
              //   width: media.width * .15,
              //   child: VocecaaButton(
              //     color: Color(0xFFFFE45E),
              //     text: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         Icon(Icons.mic),
              //         SizedBox(width: 3),
              //         Text(
              //           'Usa microfono',
              //           style:
              //               GoogleFonts.poppins(fontSize: media.width * .013),
              //         )
              //       ],
              //     ),
              //     onTap: () {
              //       // cubit.saveTable();
              //       //Navigator.pop(context);
              //     },
              //   ),
              // ),
            ],
          ),
          Spacer(),
          SizedBox(
            width: double.maxFinite,
            child: VocecaaButton(
              color: ConstantGraphics.colorYellow,
              text: AutoSizeText(
                'Avvia ricerca',
                style: GoogleFonts.poppins(
                  fontSize:
                      isLandscape ? media.width * .015 : media.height * .018,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => cubit.getImageList(),
            ),
          ),
          Spacer(),
          Expanded(
            flex: 10,
            child: Container(
              // height: media.height * .4,
              width: double.maxFinite,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[200],
              ),
              child: BlocBuilder<SearchVoceImagesCubit, SearchVoceImagesState>(
                builder: (context, state) {
                  if (state is SearchVoceImagesloaded) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            isLandscape ? 4 : 3, // Numero di colonne
                        mainAxisSpacing: 10.0, // Spazio verticale tra le righe
                        crossAxisSpacing: 10.0,
                        childAspectRatio: media.width < 600
                            ? 6 / 5
                            : 6 / 5, // Spazio orizzontale tra le colonne
                      ),
                      itemCount: state.imageList.length,
                      itemBuilder: (context, index) => VocecaaPictogramSimple(
                        caaImageStringCoding:
                            state.imageList[index].stringCoding,
                        onTap: () =>
                            Navigator.pop(context, state.imageList[index]),
                      ),
                    );
                  } else if (state is SearchVoceImagesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
