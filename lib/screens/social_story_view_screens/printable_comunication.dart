import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/social_story_cubit/social_story_comm_detail_cubit_cubit.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';

class PrintableCommuication extends StatefulWidget {
  const PrintableCommuication({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<PrintableCommuication> createState() => _PrintableCommuicationState();
}

class _PrintableCommuicationState extends State<PrintableCommuication> {
  GlobalKey _globalKey = new GlobalKey();
  late SocialStoryCommDetailCubitCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<SocialStoryCommDetailCubitCubit>(context);
    cubit.insertGlobalKey(_globalKey);
  }

  Widget _buildLandscapeLayout({
    required SocialStory socialStory,
  }) {
    Size media = MediaQuery.of(context).size;
    return RepaintBoundary(
      key: _globalKey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: media.height * .1,
            width: media.height * .1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey[300],
            ),
            // padding: EdgeInsets.all(20),
            margin: const EdgeInsets.fromLTRB(15.0, 15, 15, 35),
            child: IconButton(
              onPressed: () {
                cubit.playAllAudios(widget.index);
              },
              icon: Icon(
                Icons.record_voice_over_rounded,
                size: media.width * .04,
                fill: 1,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: media.height * .23,
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      socialStory.comunicativeSessionList[widget.index].title,
                      style: GoogleFonts.poppins(
                        fontSize: media.width * .013,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: media.height * .12,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, imageIndex) => VocecaaPictogram(
                          caaImage: socialStory
                              .comunicativeSessionList[widget.index]
                              .imageList[imageIndex],
                          isErasable: false,
                          color: Theme.of(context).primaryColor,
                        ),
                        separatorBuilder: (_, __) => SizedBox(
                          width: 10,
                        ),
                        itemCount: socialStory
                            .comunicativeSessionList[widget.index]
                            .imageList
                            .length,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout({required SocialStory socialStory}) {
    Size media = MediaQuery.of(context).size;
    return RepaintBoundary(
      key: _globalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            socialStory.comunicativeSessionList[widget.index].title,
            style: GoogleFonts.poppins(
              fontSize: media.height * .016,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3),
          Container(
            height: media.height * .12,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, imageIndex) => VocecaaPictogram(
                heightFactor: 0.22,
                widthFactor: 0.27,
                fontSizeFactor: .035,
                caaImage: socialStory.comunicativeSessionList[widget.index]
                    .imageList[imageIndex],
                isErasable: false,
                color: Theme.of(context).primaryColor,
              ),
              separatorBuilder: (_, __) => SizedBox(
                width: 10,
              ),
              itemCount: socialStory
                  .comunicativeSessionList[widget.index].imageList.length,
            ),
          ),
          GestureDetector(
            onTap: () {
              cubit.playAllAudios(widget.index);
            },
            child: Container(
              height: media.height * .05,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.grey[300],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.record_voice_over_rounded,
                    size: media.height * .025,
                    fill: 1,
                  ),
                  SizedBox(width: 5),
                  Center(
                    child: AutoSizeText(
                      "Riproduci Audio",
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        color: Colors.black87,
                        fontSize: media.height * .018,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return BlocBuilder<SocialStoryCommDetailCubitCubit,
        SocialStoryCommDetailCubitState>(
      builder: (context, state) {
        if (state is SocialStoryTargetChanged) {
          return isLandscape
              ? _buildLandscapeLayout(socialStory: state.socialStory)
              : _buildPortraitLayout(socialStory: state.socialStory);
        } else {
          return Container();
        }
      },
    );
  }
}
