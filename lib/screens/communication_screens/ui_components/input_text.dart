import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/operator_communication_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';

class OperatorInputTextArea extends StatefulWidget {
  OperatorInputTextArea({
    Key? key,
    required this.onChanged,
    this.controller,
    this.maxLines = 5,
    this.initialValue,
  }) : super(key: key);

  final TextEditingController? controller;
  final Function(String text) onChanged;
  final String? initialValue;
  final int maxLines;

  @override
  State<OperatorInputTextArea> createState() => _OperatorInputTextAreaState();
}

class _OperatorInputTextAreaState extends State<OperatorInputTextArea> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    int maxLines = widget.maxLines;
    // final controller = TextEditingController(text: textValue);
    // controller.selection = TextSelection.fromPosition(
    //     TextPosition(offset: controller.text.length));

    return Container(
      width: orientation == Orientation.landscape
          ? media.width * 0.75
          : media.width * 0.9,
      child: BlocListener<SpeechToTextCubit, SpeechToTextState>(
        listener: (context, state) {
          if (state is SpeechToTextDone) {
            final cubit = BlocProvider.of<OperatorCommunicationCubit>(context);
            cubit.updatePhrase(state.result);
            setState(() {
              controller.text = state.result;
            });
          }
        },
        child: TextFormField(
          controller: widget.controller,
          maxLines: maxLines,
          decoration: InputDecoration(
              labelText: 'Registrare una frase o inserire il testo manualmente',
              contentPadding: EdgeInsets.symmetric(
                horizontal: media.width * 0.01,
                vertical: media.height * 0.01,
              ),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never),
          showCursor: true,
          style: GoogleFonts.poppins(
            fontSize: orientation == Orientation.landscape
                ? media.height * 0.025
                : media.height * .015,
          ),
          onChanged: (value) => widget.onChanged(value),
        ),
      ),
    );
  }
}
