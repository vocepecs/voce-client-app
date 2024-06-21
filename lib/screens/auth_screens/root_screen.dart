import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voce/cubit/auth_cubit.dart';
import 'package:voce/cubit/home_page_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/screens/auth_screens/login_screen.dart';
import 'package:voce/services/auth_repository.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/mbs/mb_confirm.dart';
import 'package:voce/widgets/vocecaa_drawer.dart';

import 'mbs/mb_error.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {

  late AuthCubit cubit;


  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<AuthCubit>(context);
    cubit.automatedLogin();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        
        // Utente loggato
        if (state is AuthStateUserLoggedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => HomePageCubit(
                  voceAPIRepository: VoceAPIRepository(),
                  authRepository: AuthRepository(),
                  userId: state.userId,
                ),
                child: VocecaaDrawer(),
              ),
            ),
          );
        }

        if (state is AuthSignUpError) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbError(
              title: 'Problema nella registrazione',
              subtitle: state.message,
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => cubit.emitNotLoggedIn());
        }

        if (state is AuthStatePasswordResetEmailSent) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Password inviata',
              subtitle:
                  'Controlla la tua email per verificare la ricezione della password temporanea',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => cubit.emitNotLoggedIn());
        }
        
        // ERRORE Credenziali invalide
        if (state is AuthStateInvalidCredentials) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbError(
              title: 'Credenziali Errate!',
              subtitle: 'Username o password errati',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) {
            var cubit = BlocProvider.of<AuthCubit>(context);
            cubit.checkToken();
          });
        } else if (state is AuthStateUserNotFound) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbError(
              title: 'Utente non trovato',
              heightFactor: 0.8,
              subtitle:
                  "L'email non risulta essere associata ad alcun utente. Clicca su \"REGISTRATI\" per creare un nuovo account",
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) {
            var cubit = BlocProvider.of<AuthCubit>(context);
            cubit.checkToken();
          });
        } else if (state is AuthStateUserEmailNotConfirmed) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbError(
              title: 'Email non confermata',
              heightFactor: 0.8,
              subtitle:
                  "L'email non risulta essere confermata. Clicca su \"REINVIA EMAIL DI CONFERMA\" per ricevere una nuova email di conferma",
              bottomWidgets: [
                TextButton(
                  onPressed: () {
                    var cubit = BlocProvider.of<AuthCubit>(context);
                    cubit.resendConfirmationEmail();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'REINVIA EMAIL DI CONFERMA',
                    style: TextStyle(
                      color: ConstantGraphics.colorPink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) {
            var cubit = BlocProvider.of<AuthCubit>(context);
            cubit.emitNotLoggedIn();
          });
        } else if (state is AuthStateUserNotEnabled) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbError(
              title: "L'utenza non è abilitata",
              heightFactor: 0.8,
              subtitle:
                  "Questo a causa di una richiesta di eliminazione dell'account. Contatta l'assistenza all'email vocepecs@unipv.it per ulteriori informazioni",
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) {
            var cubit = BlocProvider.of<AuthCubit>(context);
            cubit.checkToken();
          });
        }
      },
      builder: (context, state) {
        if (state is AuthStateNotLoggedIn) {
          return LoginScreen();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
