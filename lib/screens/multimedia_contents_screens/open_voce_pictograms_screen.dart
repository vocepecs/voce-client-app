import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/open_voce_pictograms_cubit.dart';
import 'package:voce/widgets/vocecaa_image_card.dart';
import 'package:voce/widgets/vocecaa_open_voce_layout.dart';
import 'package:voce/widgets/vocecaa_searchbar.dart';
import 'package:voce/widgets/vocecca_card.dart';

class OpenVocePictogramScreen extends StatefulWidget {
  const OpenVocePictogramScreen({Key? key}) : super(key: key);

  @override
  State<OpenVocePictogramScreen> createState() =>
      _OpenVocePictogramScreenState();
}

class _OpenVocePictogramScreenState extends State<OpenVocePictogramScreen> {
  late OpenVocePictogramsCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<OpenVocePictogramsCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpenVocePictogramsCubit, OpenVocePictogramsState>(
      builder: (context, state) {
        return VocecaaOpenVoceLayout(
          pageTitle: 'Open VOCE | Pittogrammi',
          headerSection: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              'Ricerca e consulta i pittogrammi presenti del database di VOCE',
              style: GoogleFonts.poppins(
                fontSize: 23,
              ),
            ),
          ),
          searchBar: VocecaaSearchBar(
            marginRatio: 0,
            hintText: 'Cerca un contenuto',
            onIconButtonPressed: () {
              cubit.searchPictograms();
            },
            onTextChange: (value) {
              cubit.updateSearchText(value);
            },
          ),
          isContentLoading: state is OpenVocePictogramsLoading,
          wrapListContents: state is OpenVocePictogramsLoaded
              ? List.generate(state.imageList.length, (index) {
                  return VocecaaImageCard(
                    caaImage: state.imageList[index],
                  );
                })
              : null,
          noContentsToWrapMessage: state is OpenVocePictogramsLoaded
              ? state.imageList.isEmpty
                  ? _buildFilterSearchFaultMessage(context)
                  : null
              : state is OpenVocePictogramsInitial
                  ? _buildInitialSearchFaultMessage(context)
                  : null,
        );
      },
    );
  }

  Widget _buildFilterSearchFaultMessage(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return VocecaaCard(
      child: SizedBox(
        width: media.width * .4,
        height: media.height * .2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.search_off,
              size: media.width * .05,
              color: Colors.black87,
            ),
            Text(
              'Nessun pittogramma trovato',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: media.width * .014,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialSearchFaultMessage(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return VocecaaCard(
      child: SizedBox(
        width: media.width * .4,
        height: media.height * .2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.search_outlined,
              size: media.width * .05,
              color: Colors.black87,
            ),
            Text(
              'Utilizza la barra di ricerca\nper cercare i pittogrammi',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: media.width * .014,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
