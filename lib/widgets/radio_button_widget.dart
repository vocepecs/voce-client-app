import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RadioButtonWidget extends StatefulWidget {
  const RadioButtonWidget({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final ValueChanged<bool> onChanged;

  @override
  _RadioButtonWidgetState createState() => _RadioButtonWidgetState();
}

class _RadioButtonWidgetState extends State<RadioButtonWidget> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // Cambia il colore del pulsante in base al valore selezionato
        backgroundColor: _isSelected ? Colors.green : Colors.grey,
        // Usa una forma rettangolare con i bordi curvi di 15
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        // Usa un testo al posto del testo vuoto
        child: AutoSizeText(
          'Settimane',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: () {
        // Aggiorna lo stato e chiama il metodo di callback
        setState(() {
          _isSelected = !_isSelected;
          widget.onChanged(_isSelected);
        });
      },
    );
  }
}
