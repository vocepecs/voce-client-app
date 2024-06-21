import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/multimedia_content_screen_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_selectable_pill.dart';
import 'package:voce/widgets/vocecca_card.dart';

class FilterPanel extends StatefulWidget {
  const FilterPanel({
    Key? key,
    required this.patientList,
  }) : super(key: key);

  final List<Patient> patientList;

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  late Map<int, bool> selectedPatientList;

  @override
  void initState() {
    super.initState();
    selectedPatientList = Map.fromIterable(
      widget.patientList,
      key: (element) => (element as Patient).id!,
      value: (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return VocecaaCard(
      hasShadow: false,
      child: Container(
        width: media.width * .8,
        height: media.height * .2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtra i pittogrammi',
              style: GoogleFonts.poppins(
                fontSize: media.width * .016,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Seleziona i soggetti per cui desideri visualizzare i pittogrammi privati',
              style: GoogleFonts.poppins(
                fontSize: media.width * .013,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              width: media.width * .55,
              height: media.height * .05,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => VocecaaSelectablePill(
                    isSelected:
                        selectedPatientList[widget.patientList[index].id]!,
                    label: widget.patientList[index].nickname,
                    onTap: (value) {
                      setState(() {
                        selectedPatientList[widget.patientList[index].id!] =
                            !value;
                      });
                      var cubit = BlocProvider.of<MultimediaContentScreenCubit>(
                          context);
                      cubit.filterByPatients(selectedPatientList);
                    }),
                separatorBuilder: (context, _) => SizedBox(width: 5),
                itemCount: widget.patientList.length,
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                VocecaaButton(
                    color: ConstantGraphics.colorYellow,
                    text: Text(
                      'Scarica private',
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .011,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      var cubit = BlocProvider.of<MultimediaContentScreenCubit>(
                          context);
                      cubit.searchPrivateImages(selectedPatientList);
                    }),
                SizedBox(width: 5),
                VocecaaButton(
                    color: ConstantGraphics.colorYellow,
                    text: Text(
                      'Vedi pubbliche',
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .011,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedPatientList = Map.fromIterable(
                          widget.patientList,
                          key: (element) => (element as Patient).id!,
                          value: (_) => false,
                        );
                        var cubit =
                            BlocProvider.of<MultimediaContentScreenCubit>(
                                context);
                        cubit.filterOnlyPublicImages();
                      });
                    }),
                SizedBox(width: 5),
                VocecaaButton(
                    color: ConstantGraphics.colorYellow,
                    text: Text(
                      'Resetta filtri',
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .011,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedPatientList = Map.fromIterable(
                          widget.patientList,
                          key: (element) => (element as Patient).id!,
                          value: (_) => false,
                        );
                        var cubit =
                            BlocProvider.of<MultimediaContentScreenCubit>(
                                context);
                        cubit.resetFilters();
                      });
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
