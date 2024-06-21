import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/dedicated_cubits/table_filter_panel_cubit.dart';
import 'package:voce/cubit/link_table_to_patient_cubit.dart';
import 'package:voce/models/user.dart';
import 'package:voce/widgets/vocecaa_labeled_switch.dart';
import 'package:voce/widgets/vocecca_card.dart';

// TODO Sostituire con VocecaaPrivacyFilterPanel
class TableFilterPanel extends StatelessWidget {
  const TableFilterPanel({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<TableFilterPanelCubit>(context);
    var cubitLinkTable = BlocProvider.of<LinkTableToPatientCubit>(context);
    return BlocListener<TableFilterPanelCubit, TableFilterPanelState>(
      listener: (context, state) {
        if (state is TableFilterPanelUpdated) {
          cubitLinkTable.updateFilters(
            state.tableFilterPrivate,
            state.tableFilterCentre,
            state.tableFilterPublic,
          );
        }
      },
      child: VocecaaCard(
        hasShadow: false,
        child: SizedBox(
          height: media.height * .15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.zero,
                dense: true,
                minVerticalPadding: 0,
                title: Text(
                  'Filtra le tabelle',
                  style: GoogleFonts.poppins(
                    fontSize: media.width * .014,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Seleziona le tabelle che vuoi visualizzare',
                  style: GoogleFonts.poppins(
                    fontSize: media.width * .013,
                  ),
                ),
              ),
              Spacer(),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  VocecaaLabeledSwitch(
                    switchInitialValue: true,
                    widthFactor: .15,
                    onChange: (value) {
                      cubit.updatePrivateFilter(value);
                    },
                    label: 'Private',
                  ),
                  VocecaaLabeledSwitch(
                    switchInitialValue: true,
                    widthFactor: .15,
                    onChange: (value) {
                      cubit.updatePublicFilter(value);
                    },
                    label: 'Pubbliche',
                  ),
                  if (user.autismCentre != null)
                    VocecaaLabeledSwitch(
                      switchInitialValue: true,
                      widthFactor: .15,
                      onChange: (value) {
                        cubit.updateCentreFilter(value);
                      },
                      label: 'Del Centro',
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
