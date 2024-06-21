import 'package:flutter/material.dart';
import 'package:voce/screens/patient_screens/layouts/landscape_layout.dart';
import 'package:voce/screens/patient_screens/layouts/portrait_layout.dart';

class PatientDetailsScreen extends StatefulWidget {
  const PatientDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData media = MediaQuery.of(context);
    bool isLandscape = media.orientation == Orientation.landscape;
    return isLandscape
        ? PatientScreenLandscapeLayout()
        : PatientScreenPortraitLayout();
  }
}
