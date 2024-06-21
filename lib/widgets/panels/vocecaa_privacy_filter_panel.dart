import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/widgets/vocecaa_labeled_switch.dart';
import 'package:voce/widgets/vocecca_card.dart';

class VocecaaPrivacyFilterPanel extends StatelessWidget {
  const VocecaaPrivacyFilterPanel({
    Key? key,
    this.showAutsimCentre = false,
    this.title,
    this.subtitle,
    this.onPrivateToggleChange,
    this.onPublicToggleChange,
    this.onCentreToggleChange,
    this.isHorizontal = false,
  }) : super(key: key);

  final bool showAutsimCentre;
  final String? title;
  final String? subtitle;
  final bool isHorizontal;

  final Function(bool value)? onPrivateToggleChange;
  final Function(bool value)? onPublicToggleChange;
  final Function(bool value)? onCentreToggleChange;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return isHorizontal
        ? _buildHorizontalFilter(media)
        : _buildVerticalFilter(context);
  }

  Widget _buildHorizontalFilter(Size media) {
    return VocecaaCard(
      hasShadow: false,
      child: SizedBox(
        height: media.height * .15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              ListTile(
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.zero,
                dense: true,
                minVerticalPadding: 0,
                title: Text(
                  title!,
                  style: GoogleFonts.poppins(
                    fontSize: media.width * .014,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: subtitle != null
                    ? Text(
                        subtitle!,
                        style: GoogleFonts.poppins(
                          fontSize: media.width * .013,
                        ),
                      )
                    : null,
              ),
            Spacer(),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                VocecaaLabeledSwitch(
                  switchInitialValue: true,
                  widthFactor: .15,
                  onChange: (value) {
                    onPrivateToggleChange!(value);
                  },
                  label: 'Private',
                ),
                VocecaaLabeledSwitch(
                  switchInitialValue: true,
                  widthFactor: .15,
                  onChange: (value) {
                    onPublicToggleChange!(value);
                  },
                  label: 'Pubbliche',
                ),
                if (showAutsimCentre)
                  VocecaaLabeledSwitch(
                    switchInitialValue: true,
                    widthFactor: .15,
                    onChange: (value) {
                      onCentreToggleChange!(value);
                    },
                    label: 'Del Centro',
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalFilter(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return VocecaaCard(
      hasShadow: false,
      child: SizedBox(
        width: orientation == Orientation.landscape ? media.width * .25 : double.maxFinite,
        height: showAutsimCentre ? media.height * .35 : media.height * .28,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              ListTile(
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.zero,
                dense: true,
                minVerticalPadding: 0,
                title: Text(
                  title!,
                  style: GoogleFonts.poppins(
                    fontSize: orientation == Orientation.landscape ? media.width * .014 : media.height * .018,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: subtitle != null
                    ? Text(
                        subtitle!,
                        style: GoogleFonts.poppins(
                          fontSize: orientation == Orientation.landscape ? media.width * .013 : media.height * .016,
                        ),
                      )
                    : null,
              ),
            Spacer(),
            Center(
              child: VocecaaLabeledSwitch(
                switchInitialValue: true,
                widthFactor: 2,
                onChange: (value) {
                  onPrivateToggleChange!(value);
                },
                label: 'Private',
              ),
            ),
            showAutsimCentre
                ? Spacer()
                : SizedBox(
                    height: 10,
                  ),
            Center(
              child: VocecaaLabeledSwitch(
                switchInitialValue: true,
                widthFactor: 2,
                onChange: (value) {
                  onPublicToggleChange!(value);
                },
                label: 'Pubbliche',
              ),
            ),
            showAutsimCentre ? Spacer() : Container(),
            showAutsimCentre
                ? Center(
                    child: VocecaaLabeledSwitch(
                      switchInitialValue: true,
                      widthFactor: 2,
                      onChange: (value) {
                        onCentreToggleChange!(value);
                      },
                      label: 'Del Centro',
                    ),
                  )
                : Container(),
            Spacer()
          ],
        ),
      ),
    );
  }
}
