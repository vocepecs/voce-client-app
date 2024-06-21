import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
  static const Color contentColorGray = Color(0xFFCCCCCC);
  static const Color contentColorBrow = Color(0xff7B3F00);

  static const Color adjectiveColor = Color(0xffef476f);
  static const Color adverbColor = Color(0xffffd166);
  static const Color nounColor = Color(0xff06d6a0);
  static const Color verbColor = Color(0xff118ab2);
  static const Color undefinedColor = Color(0xff073b4c);

  static const List<Color> colorList_1 = [
    Color(0xff54478c),
    Color(0xff2c699a),
    Color(0xff048ba8),
    Color(0xff0db39e),
    Color(0xff16db93),
    Color(0xff83e377),
    Color(0xffb9e769),
    Color(0xffefea5a),
    Color(0xfff1c453),
    Color(0xfff29e4c),
  ];

  static const List<Color> colorList_2 = [
    Color(0xff012a4a),
    Color(0xff013a63),
    Color(0xff01497c),
    Color(0xff014f86),
    Color(0xff2a6f97),
    Color(0xff2c7da0),
    Color(0xff468faf),
    Color(0xff61a5c2),
    Color(0xff89c2d9),
    Color(0xffa9d6e5),
  ];
}

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * value).round(),
      (green * value).round(),
      (blue * value).round(),
    );
  }

  Color lighten([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = percent / 100;
    return Color.fromARGB(
      alpha,
      (red + ((255 - red) * value)).round(),
      (green + ((255 - green) * value)).round(),
      (blue + ((255 - blue) * value)).round(),
    );
  }

  Color avg(Color other) {
    final red = (this.red + other.red) ~/ 2;
    final green = (this.green + other.green) ~/ 2;
    final blue = (this.blue + other.blue) ~/ 2;
    final alpha = (this.alpha + other.alpha) ~/ 2;
    return Color.fromARGB(alpha, red, green, blue);
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

class LegendWidget extends StatelessWidget {
  const LegendWidget({
    key,
    required this.name,
    required this.color,
  });
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          name,
          style: const TextStyle(
            color: Color(0xff757391),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class LegendsListWidget extends StatelessWidget {
  const LegendsListWidget({
    key,
    required this.legends,
  });
  final List<Legend> legends;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: legends
          .map(
            (e) => LegendWidget(
              name: e.name,
              color: e.color,
            ),
          )
          .toList(),
    );
  }
}

class Legend {
  Legend(this.name, this.color);
  final String name;
  final Color color;
}
