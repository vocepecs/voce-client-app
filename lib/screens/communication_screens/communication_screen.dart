import 'package:flutter/material.dart';
import 'package:voce/models/user.dart';
import 'package:voce/screens/communication_screens/layouts/landscape_layout.dart';
import 'package:voce/screens/communication_screens/layouts/portrait_layout.dart';

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({Key? key, required this.user}) : super(key: key);

  _CommunicationScreenState createState() => _CommunicationScreenState();
  final User user;
}

class _CommunicationScreenState extends State<CommunicationScreen>{

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: OrientationBuilder(builder: (context, orientation) {
        if(orientation == Orientation.portrait){
          return CommunicationScreenPortrait(user: widget.user,);
        } else {
          return CommunicationScreenLandscape(user: widget.user);
        }
      },),
    );
  }
}
