import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/screens/communication_screens/pages/operator_page.dart';
import 'package:voce/screens/communication_screens/pages/patient_page.dart';
import 'package:voce/screens/communication_screens/ui_components/btn_communication_menu.dart';
import 'package:voce/widgets/mbs/mb_info.dart';

class CommunicationScreenLandscape extends StatefulWidget {
  const CommunicationScreenLandscape({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<CommunicationScreenLandscape> createState() =>
      _CommunicationScreenLandscapeState();
}

class _CommunicationScreenLandscapeState
    extends State<CommunicationScreenLandscape>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Patient patient;

  @override
  void initState() {
    super.initState();
    patient =
        widget.user.patientList!.firstWhere((element) => element.isActive!);
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();

    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  String text = "";
  bool isListening = false;

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
            "In questa pagina è possibile utilizzare la tabella CAA selezionata e il traduttore per poter comunicare con il profilo selezionato.",
            textAlign: TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .018,
            ),
          ),
          Text(
            isLandscape
                ? "Usa i pulsanti di navigazione in alto per navigare tra le pagine e creare le frasi\n"
                : "Usa i pulsanti di navigazione in basso per navigare tra le pagine e creare le frasi\n",
            textAlign: TextAlign.start,
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
    Size media = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: ConstantGraphics.colorBlue,
        appBar: AppBar(
          toolbarHeight: media.height * 0.1,
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          title: Align(
              alignment: Alignment(-0.95, 0.0),
              child: Text(
                "Sessione comunicativa",
                style: GoogleFonts.poppins(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              )),
          actions: [
            Container(
              child: Center(
                child: Container(
                  width: media.width * 0.25,
                  height: media.height * 0.05,
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: Color(0xFFFFE45E),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    labelStyle:
                        GoogleFonts.poppins(fontSize: media.height * 0.025),
                    tabs: [
                      Tab(
                        text: "${patient.nickname}",
                      ),
                      Tab(
                        text: "Traduttore",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () => _showInfoModal(),
              icon: Image.asset("assets/icons/icon_info.png"),
            ),
            BtnCommunicationMenu(user: widget.user),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
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
      ),
    );
  }
}
