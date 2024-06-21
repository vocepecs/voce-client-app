import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/widgets/vocecca_card.dart';

class PatientListItem extends StatelessWidget {
  const PatientListItem({
    Key? key,
    required this.patient,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  final Patient patient;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onTap(),
      child: Center(
        child: Container(
          width: media.width * .74,
          height: media.height * .2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: media.width * .7,
                child: VocecaaCard(
                  hasShadow: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: media.width * .3,
                        child: ListTile(
                          title: Text(
                            patient.nickname,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: media.width * .015),
                          ),
                          leading: Icon(
                            Icons.person_pin,
                            size: media.width * .04,
                          ),
                          subtitle: Text(
                            'Livello comunicativo: ${patient.communicationLevel}',
                            style: GoogleFonts.poppins(
                              fontSize: media.width * .015,
                            ),
                          ),
                        ),
                      ),
                      // Spacer(),
                      Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${patient.tableList.length}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: media.width * .025,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: ' Tabelle associate',
                                style: GoogleFonts.poppins(
                                  fontSize: media.width * .015,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                      Container(
                        width: media.width * .2,
                        child: ListTile(
                          title: Text(
                            'Note',
                            style: GoogleFonts.poppins(
                              fontSize: media.width * .012,
                            ),
                          ),
                          subtitle: Container(
                            height: media.height * .08,
                            child: SingleChildScrollView(
                              child: Text(
                                patient.notes ?? '',
                                style: GoogleFonts.poppins(
                                    fontSize: media.width * .015),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              isSelected
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: media.width * .05,
                        height: media.width * .05,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green[300],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check_circle_outline_rounded,
                            size: media.width * .04,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
