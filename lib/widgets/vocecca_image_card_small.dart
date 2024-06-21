import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class VocecaaImageCardSmall extends StatelessWidget {
  const VocecaaImageCardSmall({
    Key? key,
    required this.actions,
    required this.imageName,
  }) : super(key: key);

  final List<Widget> actions;
  final String imageName;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      width: media.width * .4,
      height: media.height * .09,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        border: Border.all(
          width: 1,
          color: Colors.black45,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(15)),
                color: Colors.grey[400],
              ),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: media.width * .03,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              child: ListTile(
                title: Text(imageName),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: actions,
          ),
        ],
      ),
    );
  }
}
