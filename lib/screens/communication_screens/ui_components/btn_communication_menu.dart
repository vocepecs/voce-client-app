import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voce/cubit/communication_settings_panel_cubit.dart';
import 'package:voce/cubit/home_page_cubit.dart';
import 'package:voce/cubit/social_story_communication_setup_cubit.dart';
import 'package:voce/models/user.dart';
import 'package:voce/screens/communication_screens/communication_setup_screen.dart';
import 'package:voce/screens/social_story_view_screens/social_story_communication_setup_screen.dart';
import 'package:voce/services/auth_repository.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/vocecaa_drawer.dart';

class BtnCommunicationMenu extends StatelessWidget {
  const BtnCommunicationMenu({
    Key? key,
    required this.user,
    this.socialStoryView = false,
  }) : super(key: key);

  final User user;
  final bool socialStoryView;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      elevation: 10,
      onSelected: (result) {
        if (result == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => HomePageCubit(
                  voceAPIRepository: VoceAPIRepository(),
                  authRepository: AuthRepository(),
                  userId: user.id!,
                ),
                child: VocecaaDrawer(),
              ),
            ),
          );
        } else if (result == 0 || result == 1) {
          socialStoryView
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => SocialStoryCommunicationSetupCubit(
                        VoceAPIRepository(),
                        user,
                      ),
                      child: SocialStoryCommunicationSetupScreen(),
                    ),
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => CommunicationSetupCubit(
                        voceAPIRepository: VoceAPIRepository(),
                        user: user,
                      ),
                      child: CommunicationSetupScreen(),
                    ),
                  ),
                );
        }
      },
      offset: Offset(0, 25),
      iconSize: 30,
      icon: Icon(
        Icons.menu,
        color: Colors.black87,
      ),
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          value: 0,
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Cambia Soggetto'),
            // subtitle: Text('Accedi per cambiare interlocutore'),
            // trailing: Icon(Icons.arrow_forward_rounded),
          ),
          textStyle: TextStyle(color: Colors.black87),
        ),
        PopupMenuItem(
          value: 1,
          child: ListTile(
            leading: Icon(Icons.table_chart),
            title: Text(
                socialStoryView ? 'Cambia Storia Sociale ' : 'Cambia Tabella'),
            // subtitle: Text(
            //     'Accedi per cambiare la tabella per la comunicazione'),
            // trailing: Icon(Icons.arrow_forward_rounded),
          ),
          textStyle: TextStyle(color: Colors.black87),
        ),
        PopupMenuItem(
          value: 2,
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Impostazioni'),
            // subtitle: Text(
            //     'Accedi per cambiare la tabella per la comunicazione'),
            // trailing: Icon(Icons.arrow_forward_rounded),
          ),
          textStyle: TextStyle(color: Colors.black87),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: 3,
          child: ListTile(
            leading: Icon(Icons.exit_to_app_rounded),
            title: Text('Esci dalla sessione'),
          ),
          textStyle: TextStyle(color: Colors.black87),
        ),
      ],
    );
  }
}
