import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/pictograms_cubit.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/widgets/vocecaa_labeled_switch.dart';
import 'package:voce/widgets/vocecca_card.dart';

class FilterByPatientPanel extends StatelessWidget {
  const FilterByPatientPanel({
    Key? key,
    required this.patientList,
    this.title,
    this.subtitle,
  }) : super(key: key);

  final List<Patient> patientList;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return VocecaaCard(
      hasShadow: false,
      child: SizedBox(
        width: orientation == Orientation.landscape ? media.width * .25 : double.maxFinite,
        height: orientation == Orientation.landscape ? media.height * .3 : media.height * .37,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              SizedBox(
                child: ListTile(
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  minVerticalPadding: 0,
                  title: Text(
                    title!,
                    style: GoogleFonts.poppins(
                      fontSize: orientation == Orientation.landscape ? media.width * .014 : media.height * .018,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: subtitle != null
                      ? Text(
                          subtitle!,
                          style: GoogleFonts.poppins(
                            fontSize: orientation == Orientation.landscape ? media.width * .013 : media.height * .016,
                          ),
                        )
                      : null,
                ),
              ),
            SizedBox(height: 10),
            Expanded(
                child: ListView.separated(
              itemBuilder: (context, index) => VocecaaLabeledSwitch(
                switchInitialValue: true,
                onChange: (value) {
                  var cubit = BlocProvider.of<PictogramsCubit>(context);
                  cubit.filterByPatients(patientList[index], value);
                },
                label: patientList[index].nickname,
              ),
              separatorBuilder: (context, _) => SizedBox(height: 5),
              itemCount: patientList.length,
            ))
          ],
        ),
      ),
    );
  }
}
