import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voce/cubit/patient_communication_cubit.dart';
import 'package:voce/models/audio_tts.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';
import 'package:voce/widgets/vocecca_card.dart';

class PatientImageBar extends StatefulWidget {
  const PatientImageBar({Key? key, required this.caaTable}) : super(key: key);

  final CaaTable caaTable;

  @override
  State<PatientImageBar> createState() => _PatientImageBarState();
}

class _PatientImageBarState extends State<PatientImageBar> {
  late PatientCommunicationCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<PatientCommunicationCubit>(context);
  }

  Widget _buildLandscapeLayout() {
    Size media = MediaQuery.of(context).size;
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            height: media.height * .17,
            // padding: EdgeInsets.fromLTRB(
            //   8.0,
            //   8.0,
            //   8.0,
            //   8.0,
            // ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: IconButton(
              onPressed: () {
                cubit.playAllAudios();
              },
              icon: Icon(
                Icons.record_voice_over_rounded,
                size: media.width * .05,
              ),
            ),
          ),
        ),
        Spacer(),
        Expanded(
          flex: 40,
          child: Container(
            height: media.height * .17,
            padding: EdgeInsets.fromLTRB(
              8.0,
              8.0,
              8.0,
              8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<PatientCommunicationCubit,
                    PatientCommunicationState>(
                  builder: (context, state) {
                    if (state is PatientCommunicationInitial) {
                      return Spacer();
                    } else if (state is PatientCommunicationLoaded) {
                      return Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => VocecaaPictogram(
                            caaImage: state.imageBar[index].item1,
                            onTap: () {
                              List<AudioTTS> audioTTSList =
                                  state.imageBar[index].item1.audioTTSList;
                              cubit.playAudio(audioTTSList);
                            },
                            color: state.imageBar[index].item2,
                            onDeletePress: () {
                              cubit.deleteImage(index);
                            },
                          ),
                          separatorBuilder: (context, _) =>
                              SizedBox(width: 8.0),
                          itemCount: state.imageBar.length,
                        ),
                      );
                    } else {
                      //TODO errore API
                      return Container();
                    }
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: media.width * .05,
                      height: media.width * .03,
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            var cubit =
                                BlocProvider.of<PatientCommunicationCubit>(
                                    context);
                            cubit.deleteLastImage(widget.caaTable);
                          },
                          icon: Icon(
                            Icons.backspace_outlined,
                            size: media.width * .03,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: media.width * .05,
                      height: media.width * .03,
                      child: Center(
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            var cubit =
                                BlocProvider.of<PatientCommunicationCubit>(
                                    context);
                            cubit.clearImageList(widget.caaTable);
                          },
                          icon: Icon(
                            Icons.delete_forever,
                            size: media.width * .03,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout() {
    Size media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          VocecaaCard(
            child: SizedBox(
              width: media.width * .9,
              height: media.height * .12,
              child: BlocBuilder<PatientCommunicationCubit,
                  PatientCommunicationState>(
                builder: (context, state) {
                  if (state is PatientCommunicationInitial) {
                    return Container();
                  } else if (state is PatientCommunicationLoaded) {
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => VocecaaPictogram(
                        widthFactor: .29,
                        heightFactor: .25,
                        fontSizeFactor: .035,
                        caaImage: state.imageBar[index].item1,
                        onTap: () {
                          List<AudioTTS> audioTTSList =
                              state.imageBar[index].item1.audioTTSList;
                          cubit.playAudio(audioTTSList);
                        },
                        color: state.imageBar[index].item2,
                        onDeletePress: () {
                          cubit.deleteImage(index);
                        },
                      ),
                      separatorBuilder: (context, _) => SizedBox(width: 8.0),
                      itemCount: state.imageBar.length,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: media.height * .08,
                  child: GestureDetector(
                    onTap: () => cubit.playAllAudios(),
                    child: VocecaaCard(
                      backgroundColor: Colors.grey[200]!,
                      child: Center(
                        child: Icon(
                          Icons.record_voice_over_rounded,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: SizedBox(
                  height: media.height * .08,
                  child: GestureDetector(
                    onTap: () => cubit.deleteAllImages(),
                    child: VocecaaCard(
                      backgroundColor: Colors.grey[200]!,
                      child: Center(
                        child: Icon(
                          Icons.delete_rounded,
                          size: media.width * .07,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: SizedBox(
                  height: media.height * .08,
                  child: GestureDetector(
                    onTap: () => cubit.deleteLastImage(widget.caaTable),
                    child: VocecaaCard(
                      backgroundColor: Colors.grey[200]!,
                      child: Center(
                        child: Icon(
                          Icons.backspace_rounded,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      return _buildPortraitLayout();
    } else {
      return _buildLandscapeLayout();
    }
  }
}
