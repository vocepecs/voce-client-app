import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voce/cubit/operator_communication_cubit.dart';
import 'package:voce/screens/auth_screens/mbs/mb_error.dart';
import 'package:voce/screens/communication_screens/pages/operator_page_edit.dart';
import 'package:voce/screens/communication_screens/pages/operator_page_translate.dart';
import 'package:voce/screens/communication_screens/ui_components/operator_image_bar.dart';

class OperatorCommunicationPage extends StatefulWidget {
  final String text;

  const OperatorCommunicationPage({
    Key? key,
    required this.text,
  }) : super(key: key);
  @override
  State<OperatorCommunicationPage> createState() =>
      _OperatorCommunicationPageState();
}

class _OperatorCommunicationPageState extends State<OperatorCommunicationPage>
    with AutomaticKeepAliveClientMixin {
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    return BlocListener<OperatorCommunicationCubit, OperatorCommunicationState>(
      listener: (context, state) {
        if (state is ImagesNotFound) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbError(
              heightFactor: .7,
              animationUrl:
                  'https://assets1.lottiefiles.com/packages/lf20_Tkwjw8.json',
              title: 'Problema nella traduzione',
              subtitle:
                  "Non sono state trovate alcune immagini durante il processo di traduzione. Potrai comunque selezionarle tra quelle proposte per completare la frase",
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) {
            var cubit = BlocProvider.of<OperatorCommunicationCubit>(context);
            controller.jumpToPage(1);
            cubit.searchImages();
          });
        } else if (state is TranslationError) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbError(
              heightFactor: .7,
              animationUrl:
                  'https://assets1.lottiefiles.com/packages/lf20_Tkwjw8.json',
              title: 'Problema nella traduzione',
              subtitle:
                  "Si è verificato un problema durante la traduzione della frase. Riprova con una frase differente",
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          );
        }
      },
      child: SingleChildScrollView(
        child: Container(
          height: orientation == Orientation.landscape
              ? media.height * .85
              : media.height * .75,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.symmetric(
            horizontal: media.width * 0.01,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: media.height * 0.015),
                child: OperatorImageBar(
                  onBtnEditTap: () => controller.jumpToPage(1),
                ),
              ),
              Expanded(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller,
                  children: [
                    OperatorPageTranslate(),
                    OperatorPageEdit(
                      onCorrectionDone: () => controller.jumpToPage(0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
