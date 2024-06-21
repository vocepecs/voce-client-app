import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileInfoListTile extends StatelessWidget {
  const ProfileInfoListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.leading,
    this.showTrailing = true,
    this.isPasswordField = false,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Function() onTap;
  final Widget? leading;
  final bool showTrailing;
  final bool isPasswordField;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    double textBaseSize =
        orientation == Orientation.landscape ? media.width : media.height;
    return Expanded(
      child: ListTile(
        minVerticalPadding: 0,
        dense: true,
        title: AutoSizeText(
          title,
          maxLines: 1,
          textAlign: TextAlign.left,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: textBaseSize * .015,
            color: Colors.black54,
          ),
        ),
        subtitle: AutoSizeText(
          (() {
            return isPasswordField ? '********' : subtitle;
          }()),
          maxLines: 1,
          textAlign: TextAlign.left,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: textBaseSize * .016,
            color: Colors.black,
          ),
        ),
        leading: leading,
        trailing: showTrailing
            ? SizedBox(
                width: orientation == Orientation.landscape
                    ? media.width * .1
                    : media.width * .4,
                child: TextButton(
                  onPressed: () => onTap(),
                  style: ButtonStyle(
                    alignment: Alignment.centerRight,
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Modifica',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: textBaseSize * .014,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(width: 1, height: 1),
      ),
    );
  }
}
