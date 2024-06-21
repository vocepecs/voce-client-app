import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/social_story_cubit/open_voce_social_stories_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/screens/social_stories_screens/open_voce_pages/highlight_stories.dart';
import 'package:voce/screens/social_stories_screens/open_voce_pages/search_stories.dart';



class OpenVoceSocialStoriesScreen extends StatefulWidget {
  const OpenVoceSocialStoriesScreen({Key? key}) : super(key: key);

  @override
  State<OpenVoceSocialStoriesScreen> createState() =>
      _OpenVoceSocialStoriesScreenState();
}

class _OpenVoceSocialStoriesScreenState
    extends State<OpenVoceSocialStoriesScreen> {
  
  int currentIndex = 0;
  late PageController controller;
  late OpenVoceSocialStoriesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<OpenVoceSocialStoriesCubit>(context);
    controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantGraphics.colorBlue,
      appBar: AppBar(
        centerTitle: false,
        foregroundColor: Colors.black87,
        elevation: 0,
        backgroundColor: ConstantGraphics.colorBlue,
        title: Text(
          'Open VOCE',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 5,
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: ConstantGraphics.colorBlue,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(),
        onTap: ((value) {
          setState(() {
            currentIndex = value;
            controller.animateToPage(
              value,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInSine,
            );
          });
        }),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/icon_popular.png",
              height: 30,
            ),
            activeIcon: Image.asset(
              "assets/icons/icon_popular.png",
              height: 30,
            ),
            label: 'In evidenza',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/icon_search.png',
              height: 30,
            ),
            activeIcon: Image.asset(
              'assets/icons/icon_search.png',
              height: 30,
            ),
            label: 'Cerca',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: PageView(
          controller: controller,
          children: [
            HighlightStoriesPage(),
            SearchStoriesPage(),
          ],
        ),
      ),
    );
  }
}
