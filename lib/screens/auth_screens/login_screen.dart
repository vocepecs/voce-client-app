import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voce/cubit/auth_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/screens/auth_screens/ui_components/auth_button.dart';
import 'package:voce/screens/auth_screens/ui_components/auth_login_checkbox.dart';
import 'package:voce/screens/auth_screens/ui_components/auth_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
    this.signUp = false,
  }) : super(key: key);

  final bool signUp;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late AuthCubit cubit;
  late final AnimationController _controller;

  bool _signupPage = false;
  bool emailContactCheckBox = false;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<AuthCubit>(context);
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLandscapeLayout(double scaleBase) {
    Widget _buildLeftSidePage() {
      return Expanded(
        flex: 4,
        child: Container(
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: Color.fromARGB(255, 155, 215, 255),
          ),
          width: scaleBase * .6,
          child: Padding(
            padding: const EdgeInsets.only(top: 38, bottom: 38),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 16),
                    child: Image.asset(
                      'assets/voce-logo.png',
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Text(
                      "Un mondo di possibilità a portata di mano con il sistema che trasforma le parole in immagini",
                      style: GoogleFonts.poppins(
                        fontSize: scaleBase * .015,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Center(
                    child: Lottie.network(
                      'https://assets5.lottiefiles.com/private_files/lf30_h04isle8.json',
                      width: scaleBase * .25,
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller
                          ..duration = composition.duration
                          ..forward();
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(97, 215, 236, 250),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(15),
                    child: ListTile(
                      title: Text(
                        !cubit.isSignupPage
                            ? 'Non sei ancora dei nostri?'
                            : 'Hai Già un account?',
                        style: GoogleFonts.poppins(
                          fontSize: scaleBase * .018,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        !cubit.isSignupPage
                            ? 'Registrati ora per accedere a tutte le funzionalità di Voce'
                            : 'Accedi per continuare a utilizzare Voce',
                        style: GoogleFonts.poppins(
                          fontSize: scaleBase * .016,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black87,
                        size: 25,
                      ),
                      onTap: () {
                        // Add your registration logic here
                        setState(() {
                          cubit.isSignupPage = !cubit.isSignupPage;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildRightSidePageLogin() {
      return Expanded(
        flex: 5,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                100.0,
                50.0,
                100.0,
                50.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(
                      'Felice di rivederti! 👋',
                      style: GoogleFonts.poppins(
                        fontSize: scaleBase * .03,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      'Inserisci le tue credenziali per accedere',
                      style: GoogleFonts.poppins(
                        fontSize: scaleBase * .025,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  AuthTextFormField(
                    onChanged: (value) {
                      cubit.email = value;
                    },
                    label: 'Email',
                    hintText: 'xyz@esempio.com',
                  ),
                  SizedBox(height: 20),
                  AuthTextFormField(
                    onChanged: (value) {
                      cubit.password = value;
                    },
                    label: 'Password',
                    obscurable: true,
                  ),
                  AuthLoginCheckbox(onChanged: (value) {
                    cubit.persistentLogin = value;
                  }),
                  SizedBox(height: 40),
                  AuthButton(
                    onTap: () => cubit.signInWithEmailAndPassword(),
                    label: 'Accedi',
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildRightSidePageSignUp() {
      return Expanded(
        flex: 5,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                50.0,
                0.0,
                50.0,
                0.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(
                      'Piacere di conoscerti! 👋',
                      style: GoogleFonts.poppins(
                        fontSize: scaleBase * .027,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      'Inserisci le tue credenziali per registrarti',
                      style: GoogleFonts.poppins(
                        fontSize: scaleBase * .022,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: AuthTextFormField(
                          onChanged: (value) {
                            cubit.username = value;
                          },
                          label: 'Nome utente',
                          hintText: 'Il tuo nome utente',
                          initialValue: cubit.username,
                        ),
                      ),
                      Expanded(
                        child: AuthTextFormField(
                          onChanged: (value) {
                            cubit.email = value;
                          },
                          label: 'Email',
                          hintText: 'xyz@esempio.com',
                          initialValue: cubit.email,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: AuthTextFormField(
                          onChanged: (value) {
                            cubit.password = value;
                          },
                          label: 'Password',
                          hintText: '8+ caratteri',
                          obscurable: true,
                          initialValue: cubit.password,
                        ),
                      ),
                      Expanded(
                        child: AuthTextFormField(
                          onChanged: (value) {
                            cubit.passwordConfirmation = value;
                          },
                          label: 'Conferma password',
                          hintText: 'Devono coincidere',
                          obscurable: true,
                          initialValue: cubit.passwordConfirmation,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    title: Text(
                      "Confermo di voler essere contattato per comunicazioni relative a Voce e questionari di gradimento",
                      style: GoogleFonts.poppins(
                        fontSize: scaleBase * .012,
                      ),
                    ),
                    value: cubit.emailCommunicationConfirmed,
                    activeColor: ConstantGraphics.colorYellow,
                    checkColor: Colors.black87,
                    onChanged: (value) {
                      cubit.emailCommunicationConfirmed = value!;
                      setState(() => emailContactCheckBox = value);
                    },
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: scaleBase * .05,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      dense: true,
                      title: Text(
                        'Confermando la registrazione dichiari di aver letto e accettato i termini e le condizioni di utilizzo di Voce',
                        style: GoogleFonts.poppins(
                          fontSize: scaleBase * .012,
                        ),
                      ),
                      subtitle: Text(
                        'Visualizza i termini e le condizioni',
                        style: GoogleFonts.poppins(
                          fontSize: scaleBase * .012,
                          color: ConstantGraphics.colorPink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        launchUrl(Uri.parse(
                            "https://vocepecs.unipv.it/wp-content/uploads/2024/01/VOCE_privacy.pdf"));
                      },
                    ),
                  ),
                  SizedBox(height: 50),
                  AuthButton(
                    onTap: () {
                      cubit.signUpWhitEmailAndPassword();
                    },
                    label: 'Registrati',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: constraints.maxHeight,
        child: Row(
          children: [
            _buildLeftSidePage(),
            !cubit.isSignupPage
                ? _buildRightSidePageLogin()
                : _buildRightSidePageSignUp(),
          ],
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(double scaleBase) {
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: constraints.maxHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Color.fromARGB(255, 155, 215, 255),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        'assets/voce-logo.png',
                        width: scaleBase * .25,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                      child: SizedBox(
                        width: scaleBase * .4,
                        child: Text(
                          "Un mondo di possibilità a portata di mano con il sistema che trasforma le parole in immagini",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: scaleBase * .02, color: Colors.black87),
                        ),
                      ),
                    ),
                    Lottie.network(
                      'https://assets5.lottiefiles.com/private_files/lf30_h04isle8.json',
                      width: scaleBase * .25,
                      controller: _controller,
                      onLoaded: (composition) {
                        _controller
                          ..duration = composition.duration
                          ..forward();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Form(
                key: formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      AuthTextFormField(
                        onChanged: (value) {
                          cubit.email = value;
                        },
                        label: 'Email',
                        hintText: 'xyz@esempio.com',
                      ),
                      SizedBox(height: 20),
                      AuthTextFormField(
                        onChanged: (value) {
                          cubit.password = value;
                        },
                        label: 'Password',
                        obscurable: true,
                      ),
                      AuthLoginCheckbox(onChanged: (value) {
                        cubit.persistentLogin = value;
                      }),
                      SizedBox(height: 30),
                      AuthButton(
                        onTap: () {},
                        label: 'Accedi',
                      ),
                      SizedBox(height: 10),
                      AuthButton(
                        onTap: () {},
                        label: 'Registrati',
                        color: Colors.grey[200]!,
                      ),
                    ] //+ buildInputs(),
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      body: SafeArea(
        child: isLandscape
            ? _buildLandscapeLayout(media.width)
            : _buildPortraitLayout(media.height),
      ),
    );
  }
}
