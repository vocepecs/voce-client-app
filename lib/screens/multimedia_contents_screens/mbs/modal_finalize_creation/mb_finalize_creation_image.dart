import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/dedicated_cubits/search_voce_images_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/image.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_pictogram_selectable.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';

class MbFinalizeCreationImage extends StatefulWidget {
  const MbFinalizeCreationImage({
    Key? key,
    required this.imageList,
  }) : super(key: key);

  final List<CaaImage> imageList;

  @override
  State<MbFinalizeCreationImage> createState() =>
      _MbFinalizeCreationImageState();
}

class _MbFinalizeCreationImageState extends State<MbFinalizeCreationImage> {
  late SearchVoceImagesCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of(context);
    cubit.setImageSelectedList(widget.imageList);
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      margin: EdgeInsets.fromLTRB(
        orientation == Orientation.landscape ? media.width * .25 : 16,
        media.height * .1,
        orientation == Orientation.landscape ? media.width * .25 : 16,
        orientation == Orientation.landscape
            ? media.height * .26
            : media.height * .12,
      ),
      padding: EdgeInsets.fromLTRB(
        15,
        15,
        15,
        0,
      ),
      decoration: BoxDecoration(
          color: Color(0xFFF9F9F9),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              widget.imageList.length == 1
                  ? 'Ci siamo quasi!'
                  : 'Serve ancora qualche dettaglio',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: orientation == Orientation.landscape
                    ? media.width * .025
                    : media.height * .02,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Di seguito puoi trovare alcune immagini consigliate in base al nome del pittogramma scelto. In alternativa puoi cercare il pittogramma più simile a quello che desideri inserire",
            style: GoogleFonts.poppins(
              fontSize: orientation == Orientation.landscape
                  ? media.width * .016
                  : media.height * .016,
            ),
          ),
          SizedBox(height: 15),
          orientation == Orientation.landscape
              ? Row(
                  children: [
                    Expanded(
                      flex: 15,
                      child: VocecaaTextField(
                        onChanged: (value) {
                          cubit.searchText = value;
                        },
                        label: "Cerca un pittogramma",
                        initialValue: "",
                      ),
                    ),
                    Spacer(flex: 1),
                    Expanded(
                      flex: 7,
                      child: VocecaaButton(
                        color: ConstantGraphics.colorYellow,
                        borderRadius: 10,
                        padding: EdgeInsets.all(20),
                        text: Text(
                          'Cerca pittogrammi',
                          style: GoogleFonts.poppins(),
                        ),
                        onTap: () {
                          cubit.getImageList();
                        },
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    SizedBox(height: 15),
                    VocecaaTextField(
                      onChanged: (value) {
                        cubit.searchText = value;
                      },
                      label: "Cerca un pittogramma",
                      initialValue: "",
                    ),
                    SizedBox(height: 15),
                    VocecaaButton(
                      color: ConstantGraphics.colorYellow,
                      borderRadius: 10,
                      padding: EdgeInsets.all(20),
                      text: Text(
                        'Cerca pittogrammi',
                        style: GoogleFonts.poppins(),
                      ),
                      onTap: () {
                        cubit.getImageList();
                      },
                    )
                  ],
                ),
          SizedBox(height: 15),
          Expanded(
            child: BlocBuilder<SearchVoceImagesCubit, SearchVoceImagesState>(
              builder: (context, state) {
                if (state is SearchVoceImagesInitial) {
                  return builImageList(widget.imageList);
                } else if (state is SearchVoceImagesloaded) {
                  return builImageList(state.imageList);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 200,
              padding: EdgeInsets.all(16),
              child: VocecaaButton(
                color: Color(0xFFFFE45E),
                text: Text(
                  'Invia',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  if (widget.imageList.length == 1) {
                    Navigator.pop(context, widget.imageList[0].id);
                  } else if (cubit.imageSelectedList.values
                      .any((element) => element == true)) {
                    cubit.imageSelectedList.forEach((key, value) {
                      if (value) {
                        Navigator.pop(context, key);
                      }
                    });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget builImageList(List<CaaImage> imageList) {
    Orientation orientation = MediaQuery.of(context).orientation;
    Size media = MediaQuery.of(context).size;
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => VocecaaPictogramSelectable(
        isSelected: cubit.imageSelectedList[imageList[index].id]!,
        caaImage: imageList[index],
        onTap: (isSelected) {
          setState(() {
            int imageId = imageList[index].id!;
            if (isSelected == false) {
              cubit.imageSelectedList[imageId] = false;
            } else if (cubit.imageSelectedList.values
                .every((element) => element == false)) {
              cubit.imageSelectedList[imageId] = true;
            }
          });
        },
        widthFactor: orientation == Orientation.landscape ? .13 : .26,
        heightFactor: orientation == Orientation.landscape ? .09 : .3,
        fontSizeFactor: orientation == Orientation.landscape ? .014 : .035,
      ),
      separatorBuilder: (_, __) => SizedBox(width: 10),
      itemCount: imageList.length,
    );
  }
}
