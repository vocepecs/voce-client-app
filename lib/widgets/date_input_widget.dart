import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DateInputWidget extends StatefulWidget {
  const DateInputWidget({
    Key? key,
    required this.label,
    required this.onChanged,
    this.initialValue = "",
  }) : super(key: key);

  final String label;
  final Function(DateTime?) onChanged;
  final String initialValue;

  @override
  _DateInputWidgetState createState() => _DateInputWidgetState();
}

class _DateInputWidgetState extends State<DateInputWidget> {
  late TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: widget.label,
              border: OutlineInputBorder(),
              labelStyle: GoogleFonts.poppins(
                fontSize: 12,
              ),
            ),
            style: GoogleFonts.poppins(fontSize: 12),
            readOnly: true,
            onTap: () async {
              // Nasconde la tastiera
              FocusScope.of(context).requestFocus(FocusNode());
              // Mostra il date picker
              await _showDatePicker(context);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    // Ottiene la data selezionata dall'utente
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    ); //.then((value) => widget.onChanged(value));
    // Aggiorna lo stato se la data è valida
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        // Formatta la data in formato testuale
        _controller.text =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';

        widget.onChanged(pickedDate);
      });
    }
  }
}
