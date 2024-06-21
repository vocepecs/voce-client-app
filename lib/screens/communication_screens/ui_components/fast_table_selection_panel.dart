import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/patient_communication_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/constants/constant_graphics.dart';

class FastTableSelectionPanel extends StatefulWidget {
  const FastTableSelectionPanel({
    Key? key,
    required this.caaTableList,
    required this.onTableChanged,
  }) : super(key: key);

  final List<CaaTable> caaTableList;
  final Function(int id) onTableChanged;

  @override
  State<FastTableSelectionPanel> createState() =>
      _FastTableSelectionPanelState();
}

class _FastTableSelectionPanelState extends State<FastTableSelectionPanel>
    with SingleTickerProviderStateMixin {
  double _widthFactor = 1;
  bool _expanded = false;
  late AnimationController _rotationController;

  late PatientCommunicationCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      upperBound: 0.5,
    );

    cubit = BlocProvider.of<PatientCommunicationCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_expanded) {
            _rotationController..reverse(from: 0.5);
            _widthFactor = 1;
          } else {
            _rotationController..forward(from: 0.0);
            _widthFactor = 1.15;
          }
          _expanded = !_expanded;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: media.width * .75 * _widthFactor,
        height: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Cambia tabella',
                  style: GoogleFonts.poppins(
                    fontSize: media.width * .012,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: media.width * .02,
                ),
                RotationTransition(
                  turns:
                      Tween(begin: 0.0, end: 1.0).animate(_rotationController),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (_expanded) {
                            _rotationController..reverse(from: 0.5);
                            _widthFactor = 1;
                          } else {
                            _rotationController..forward(from: 0.0);
                            _widthFactor = 1.15;
                          }
                          _expanded = !_expanded;
                        });
                      },
                      iconSize: media.width * .02,
                      icon: Icon(Icons.arrow_forward_rounded)),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
                child: SizedBox(
              width: media.width * .15,
              child: Padding(
                padding: EdgeInsets.only(right: media.width * .016, bottom: 10),
                child: ListView.separated(
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      if (_expanded) {
                        // cubit.changeSocialStoryTarget(index);
                        widget.onTableChanged(widget.caaTableList[index].id!);
                      }
                    },
                    child: Container(
                      height: media.height * .12,
                      width: media.width * .12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          widget.caaTableList[index].imageStringCoding != null
                              ? _imageFromBase64String(
                                  widget.caaTableList[index].imageStringCoding!,
                                  media.width * .05)
                              : Icon(
                                  Icons.image_not_supported_outlined,
                                  size: media.width * .05,
                                  color: Colors.black54,
                                ),
                          Expanded(
                            child: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(15)),
                                color: ConstantGraphics.colorBlue,
                              ),
                              child: Center(
                                child: AutoSizeText(
                                    '${widget.caaTableList[index].name}',
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: media.width * .01)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (_, __) => SizedBox(height: 10),
                  itemCount: widget.caaTableList.length,
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Image _imageFromBase64String(String base64String, double width) {
    return Image.memory(
      base64Decode(base64String.substring(2, base64String.length - 1)),
      width: width,
    );
  }
}
