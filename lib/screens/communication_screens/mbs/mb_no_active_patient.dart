import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/set_active_patient_cubit.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/screens/communication_screens/ui_components/patient_list_item.dart';
import 'package:voce/widgets/close_line_top_modal.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class MbNoActivePatient extends StatefulWidget {
  const MbNoActivePatient({Key? key}) : super(key: key);

  @override
  _MbNoActivePatientState createState() => _MbNoActivePatientState();
}

class _MbNoActivePatientState extends State<MbNoActivePatient> {
  late List<SelectableItem> selectableItemList = [];

  @override
  void initState() {
    super.initState();
    var cubit = BlocProvider.of<SetActivePatientCubit>(context);
    cubit.getPatientList().forEach((element) {
      selectableItemList.add(SelectableItem(patient: element));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return BlocListener<SetActivePatientCubit, SetActivePatientState>(
      listener: (context, state) {
        if (state is SetActivePatientDone) {
          Navigator.pop(context);
        }
      },
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: CloseLineTopModal()),
                  SizedBox(height: media.height * .05),
                  Container(
                    child: Text(
                      'Seleziona un soggetto',
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .02,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: media.height * .01),
                  Container(
                    child: Text(
                      'Al momento non è presente nessun soggetto attivo per la comunicazione.\nSelezionalo dalla lista per poter proseguire',
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .015,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  Patient patient = selectableItemList[index].patient;
                  return PatientListItem(
                    patient: patient,
                    isSelected: selectableItemList[index].isSelected,
                    onTap: () {
                      setState(() {
                        selectableItemList.asMap().forEach((i, e) {
                          if (i != index) {
                            e.isSelected = false;
                          }
                        });
                        selectableItemList[index].isSelected =
                            !selectableItemList[index].isSelected;
                      });
                    },
                  );
                },
                separatorBuilder: (context, _) => SizedBox(height: 10.0),
                itemCount: selectableItemList.length,
              ),
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
                    if (selectableItemList
                        .any((element) => element.isSelected)) {
                      var cubit =
                          BlocProvider.of<SetActivePatientCubit>(context);
                      cubit.setActivePatient(
                        selectableItemList
                            .firstWhere((element) => element.isSelected)
                            .patient
                            .id!,
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SelectableItem {
  final Patient patient;
  bool isSelected;

  SelectableItem({
    required this.patient,
    this.isSelected = false,
  });
}
