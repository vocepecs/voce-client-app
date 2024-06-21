import 'package:flutter/material.dart';

class VocecaaOpenVoceLayout extends StatelessWidget {
  const VocecaaOpenVoceLayout({
    Key? key,
    this.isContentLoading = false,
    required this.pageTitle,
    this.headerSection,
    this.searchBar,
    this.wrapListContents,
    this.noContentsToWrapMessage,
  }) : super(key: key);

  final bool isContentLoading;
  final String pageTitle;
  final Widget? headerSection;
  final Widget? searchBar;
  final List<Widget>? wrapListContents;
  final Widget? noContentsToWrapMessage;

  bool _buildHeaderSection() => headerSection != null;
  bool _buildSearchBar() => searchBar != null;
  bool _buildWrapListContents() => wrapListContents != null;
  bool _buildNoContentsToWrap() => noContentsToWrapMessage != null;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          pageTitle,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_buildHeaderSection())
            Padding(
              padding: EdgeInsets.symmetric(horizontal: media.width * .02),
              child: headerSection,
            ),
          if (_buildSearchBar())
            Padding(
              padding: EdgeInsets.all(50.0),
              child: searchBar,
            ),
          if (isContentLoading)
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (_buildWrapListContents())
            Expanded(
              flex: 10,
              child: Center(
                child: _buildWrap(),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildWrap() {
    if (_buildWrapListContents()) {
      if (wrapListContents!.isNotEmpty) {
        return SingleChildScrollView(
          child: Wrap(
            direction: Axis.horizontal,
            spacing: 10,
            runSpacing: 10,
            children: wrapListContents!,
          ),
        );
      } else if (_buildNoContentsToWrap()) {
        return Center(
          child: noContentsToWrapMessage,
        );
      } else {
        return SizedBox();
      }
    } else {
      return SizedBox();
    }
  }
}
