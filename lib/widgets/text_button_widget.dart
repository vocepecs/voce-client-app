import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        // Rimuove i bordi dal pulsante
        shape: RoundedRectangleBorder(
          side: BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Usa il testo passato come parametro
          Text(
            text,
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          // Aggiunge uno spazio tra il testo e l'icona
          SizedBox(width: 5),
          // Usa l'icona passata come parametro
          Icon(icon, size: 18),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
