import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/widgets/mbs/mb_info.dart';

class PortraitLayout extends StatefulWidget {
  const PortraitLayout({
    Key? key,
    required this.appBarTitle,
    this.appBarButtonLeading,
    required this.columnWidgets,
  }) : super(key: key);

  final String appBarTitle;
  final Widget? appBarButtonLeading;
  final List<Widget> columnWidgets;

  @override
  State<PortraitLayout> createState() => _PortraitLayoutState();
}

class _PortraitLayoutState extends State<PortraitLayout> {



  void _showInfoModal() {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    showModalBottomSheet(
      context: context,
      builder: (context) => MbsVoceInfo(
        title: "Schemata principale",
        contents: [
          Text(
            "Questa è la schermata principale dell'applicazione Voce.\nDa qui puoi accedere alle diverse sezioni per creare nuove tabelle, nuove storie sociali e nuovi pittogrammi.",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
            ),
          ),
          Text(
            "Se risconti problemi di visualizzazione per l'applicazione ti consigliamo di ridurre la dimensione del testo dalle impostazioni del tuo dispositivo.",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          widget.appBarTitle,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        leading: widget.appBarButtonLeading,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
                            onPressed: () => _showInfoModal(),
                            icon: Image.asset("assets/icons/icon_info.png"),
                          ),
        ],
      ),
      body: Column(
        children: widget.columnWidgets,
      ),
    );
  }
}
