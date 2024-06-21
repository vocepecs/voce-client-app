import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:voce/cubit/edit_image_cubit.dart';
import 'package:voce/cubit/pictograms_cubit.dart';
import 'package:voce/models/image.dart';
import 'package:voce/screens/multimedia_contents_screens/mbs/mb_image_edit.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/mbs/mb_yes_or_no.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecca_card.dart';

class VocecaaImageCard extends StatelessWidget {
  const VocecaaImageCard({
    Key? key,
    required this.caaImage,
    this.patientsImage = const [],
  }) : super(key: key);

  final CaaImage caaImage;
  final List<String> patientsImage;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return VocecaaCard(
      padding: EdgeInsets.zero,
      hasShadow: true,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: SizedBox(
              height: media.height * .15,
              child: Center(
                child: imageFromBase64String(caaImage.stringCoding),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    caaImage.label,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Creata il ${DateFormat('yyyy-MM-dd').format(caaImage.insertDate)}',
                    style: GoogleFonts.poppins(),
                  ),
                  if (patientsImage.isNotEmpty)
                    SizedBox(
                      height: media.height * .03,
                      width: media.width * .3,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey[300],
                          ),
                          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                          child: Center(
                            child: AutoSizeText(
                              patientsImage[index],
                              maxLines: 1,
                              strutStyle: StrutStyle.disabled,
                              style: GoogleFonts.poppins(
                                fontSize: orientation == Orientation.landscape
                                    ? media.width * .01
                                    : media.height * .015,
                              ),
                            ),
                          ),
                        ),
                        separatorBuilder: (_, __) => SizedBox(width: 10),
                        itemCount: patientsImage.length,
                      ),
                    ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: media.height * .05,
                        child: VocecaaButton(
                          color: Color(0xFFFFE45E),
                          text: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                size: 18.0,
                              ),
                              SizedBox(width: 8.0),
                              AutoSizeText(
                                'Modifica',
                                maxLines: 1,
                                style: GoogleFonts.poppins(),
                              )
                            ],
                          ),
                          onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (context) => BlocProvider(
                              create: (context) => EditImageCubit(
                                voceAPIRepository: VoceAPIRepository(),
                              ),
                              child: MbImageEdit(
                                image: caaImage,
                              ),
                            ),
                            backgroundColor: Colors.black.withOpacity(0),
                            isScrollControlled: true,
                          ).then((value) {
                            if (value == true) {
                              BlocProvider.of<PictogramsCubit>(context)
                                  .getUserPictograms();
                            }
                          }),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      SizedBox(
                        height: media.height * .05,
                        child: VocecaaButton(
                          color: Colors.red[200]!,
                          text: Row(
                            children: [
                              Icon(
                                Icons.delete,
                                size: 18.0,
                              ),
                              SizedBox(width: 8.0),
                              AutoSizeText(
                                'Elimina',
                                maxLines: 1,
                                style: GoogleFonts.poppins(),
                              )
                            ],
                          ),
                          onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (context) => MbYesOrNo(
                              title:
                                  'Confermi di voler eliminare il pittogramma ?',
                            ),
                            backgroundColor: Colors.black.withOpacity(0),
                            isScrollControlled: true,
                          ).then((value) {
                            if (value == true) {
                              BlocProvider.of<PictogramsCubit>(context)
                                  .deletePictogram(caaImage);
                            }
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(
        base64String.substring(2, base64String.length - 1),
      ),
      fit: BoxFit.cover,
    );
  }
}
