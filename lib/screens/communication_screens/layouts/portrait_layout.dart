import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/vocal_profile.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/screens/communication_screens/pages/operator_page.dart';
import 'package:voce/screens/communication_screens/pages/patient_page.dart';
import 'package:voce/screens/communication_screens/ui_components/btn_communication_menu.dart';
import 'package:voce/widgets/mbs/mb_info.dart';

class CommunicationScreenPortrait extends StatefulWidget {
  const CommunicationScreenPortrait({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<CommunicationScreenPortrait> createState() =>
      _CommunicationScreenPortraitState();
}

class _CommunicationScreenPortraitState
    extends State<CommunicationScreenPortrait> {
  int currentIndex = 0;
  late PageController controller;
  late Patient patient;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    patient = widget.user.patientList!.firstWhere(
      (element) => element.isActive!,
    );
  }

  String text = "";

  void _showInfoModal() {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    showModalBottomSheet(
      context: context,
      builder: (context) => MbsVoceInfo(
        title: "Sessione comunicativa",
        contents: [
          Text(
            "In questa pagina è possibile utilizzare la tabella CAA selezionata e il traduttore per poter comunicare con il profilo selezionato.\n",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .018,
            ),
          ),
          Text(
            isLandscape
                ? "Usa i pulsanti di navigazione in alto per navigare tra le pagine e creare le frasi\n"
                : "Usa i pulsanti di navigazione in basso per navigare tra le pagine e creare le frasi\n",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .018,
            ),
          ),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: GoogleFonts.poppins(
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: "Comunicazione soggetto -> operatore/familiare\n",
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .018,
                  ),
                ),
                TextSpan(
                  text:
                      "Utilizza la pagina principale per comporre la frase desiderata selezionando i pittogrammi presenti nella tabella\n\n",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .018,
                  ),
                ),
                TextSpan(
                  text: "Comunicazione operatore/familiare -> soggetto\n",
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .018,
                  ),
                ),
                TextSpan(
                  text:
                      "Utilizza il traduttore per creare una serie di pittogrammi a partire da una frase testuale.\n\n",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .018,
                  ),
                ),
                TextSpan(
                  text:
                      "Puoi usare il microfono per registrare la frase e compilare automaticamente l'area di testo con la frase da tradurre.",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .018,
                  ),
                ),
                TextSpan(
                  text: " Clicca sul pusalnte ",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .018,
                  ),
                ),
                WidgetSpan(
                  child: Icon(
                    Icons.spatial_audio_off_sharp,
                    size:
                        isLandscape ? media.width * .015 : media.height * .018,
                  ),
                ),
                TextSpan(
                  text: " Per avviare la sintetizzazione vocale della frase",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .018,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black.withOpacity(0),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantGraphics.colorBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          "Sessione comunicativa",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showInfoModal(),
            icon: Image.asset("assets/icons/icon_info.png"),
          ),
          BtnCommunicationMenu(user: widget.user)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 5,
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: ConstantGraphics.colorBlue,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(),
        onTap: ((value) {
          setState(() {
            currentIndex = value;
            controller.animateToPage(
              value,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInSine,
            );
          });
        }),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              patient.vocalProfile == VocaProfile.FEMALE
                  ? "assets/icons/icon_girl_inactive.png"
                  : "assets/icons/icon_boy_inactive.png",
              height: 30,
            ),
            activeIcon: Image.asset(
              patient.vocalProfile == VocaProfile.FEMALE
                  ? "assets/icons/icon_girl.png"
                  : "assets/icons/icon_boy.png",
              height: 30,
            ),
            label: '${patient.nickname}',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/icon_translate_inactive.png",
              height: 30,
            ),
            activeIcon: Image.asset(
              "assets/icons/icon_translate.png",
              height: 30,
            ),
            label: 'Traduttore',
          ),
        ],
      ),
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          PatientCommunicationPage(
            caaTable:
                patient.tableList.firstWhere((element) => element.isActive),
          ),
          OperatorCommunicationPage(
            text: this.text,
          ),
        ],
      ),
    );
  }
}
