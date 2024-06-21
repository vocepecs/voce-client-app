import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/screens/communication_settings_screen/ui_components/subject_selection.dart';
import 'package:voce/screens/communication_settings_screen/ui_components/system_settings.dart';

class CommunicationSettingsScreen extends StatefulWidget {
  _CommunicationSettingsScreenState createState() =>
      _CommunicationSettingsScreenState();
}

class _CommunicationSettingsScreenState
    extends State<CommunicationSettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          toolbarHeight: media.height * 0.1,
          automaticallyImplyLeading: false,
          title: Align(
            alignment: Alignment(-0.95, 0.0),
            child: Text(
              "Impostazioni",
              style: GoogleFonts.poppins(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            Container(
              child: Center(
                child: Container(
                  width: media.width * 0.25,
                  height: media.height * 0.05,
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Color(0xFFFFE45E),
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    labelStyle:
                        GoogleFonts.poppins(fontSize: media.height * 0.025),
                    tabs: [
                      Tab(
                        text: "Generali",
                      ),
                      Tab(
                        text: "Sistema",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                iconSize: media.height * 0.066,
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            SubjectSelectionScreen(),
            SystemSettingsScreen(),
          ],
        ),
      ),
    );
  }
}
