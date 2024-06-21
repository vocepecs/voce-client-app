import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/auth_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/screens/auth_screens/mbs/mb_forgot_password.dart';

class AuthLoginCheckbox extends StatefulWidget {
  const AuthLoginCheckbox({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  final Function(bool value) onChanged;

  @override
  State<AuthLoginCheckbox> createState() => _AuthLoginCheckboxState();
}

class _AuthLoginCheckboxState extends State<AuthLoginCheckbox> {
  late AuthCubit cubit;
  bool _persistentLogin = false;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<AuthCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    final double scaleBase = MediaQuery.of(context).size.width < 600
        ? MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.width;
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: _persistentLogin,
              activeColor: Color(0xffffe45e),
              checkColor: Colors.black87,
              onChanged: (value) {
                widget.onChanged(value!);
                setState(() {
                  _persistentLogin = value;
                });
              },
            ),
            Text(
              'Rimani collegato',
              style: GoogleFonts.poppins(
                fontSize: scaleBase * .012,
                color: Colors.black87,
                // fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => VoceModalForgotPassword(),
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  isDismissible: true,
                ).then((value) {
                  if (value != null) {
                    cubit.sendPasswordResetEmail(value);
                  }
                });
              },
              child: Text(
                'Password dimenticata?',
                style: TextStyle(
                  color: ConstantGraphics.colorPink,
                  fontSize: scaleBase * .012,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
