import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/multimedia_content_screen_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_selectable_pill.dart';

class DownloadByPatientPanel extends StatefulWidget {
  const DownloadByPatientPanel({
    Key? key,
    required this.patientList,
  }) : super(key: key);

  final List<Patient> patientList;

  @override
  State<DownloadByPatientPanel> createState() => _DownloadByPatientPanelState();
}

class _DownloadByPatientPanelState extends State<DownloadByPatientPanel> {
  late Map<int, bool> downloadSelectedPatients;

  @override
  void initState() {
    super.initState();
    downloadSelectedPatients = Map.fromIterable(
      widget.patientList,
      key: (element) => element.id,
      value: (_) => false,
    );
  }

  void _updateDownloadSelectedPatients(int patientId, bool value) {
    downloadSelectedPatients.update(patientId, (_) => value);
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<MultimediaContentScreenCubit>(context);
    return Container(
      padding: EdgeInsets.all(8.0),
      height: media.height * .3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Scarica le immagini dei soggetti',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Scarica tutte le immagini private per i soggetti selezionati',
              style: GoogleFonts.poppins(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                runSpacing: 2,
                spacing: 5,
                direction: Axis.horizontal,
                runAlignment: WrapAlignment.start,
                alignment: WrapAlignment.start,
                children: List.generate(
                  widget.patientList.length,
                  (index) => VocecaaSelectablePill(
                    label: widget.patientList[index].nickname,
                    onTap: (value) {
                      setState(() {
                        _updateDownloadSelectedPatients(
                          widget.patientList[index].id!,
                          !value,
                        );
                        // cubit.updateDownloadSelectedPatients(
                        //   widget.patientList[index].id!,
                        //   !value,
                        // );
                      });
                    },
                    isSelected:
                        downloadSelectedPatients[widget.patientList[index].id]!,
                  ),
                ),
              ),
            ),
          ),
          VocecaaButton(
            color: ConstantGraphics.colorYellow,
            text: Text(
              'Scarica',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              cubit.searchPrivateImages(downloadSelectedPatients);
            },
          )
        ],
      ),
    );
  }
}
