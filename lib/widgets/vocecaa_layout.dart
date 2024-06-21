import 'package:flutter/material.dart';

class VocecaaLayout extends StatelessWidget {
  const VocecaaLayout(
      {Key? key,
      required this.pageTitle,
      this.isContentLoading = false,
      this.searchBar,
      this.privacyFilterPanel,
      this.downloadCentreContentPanel,
      this.openVocePanel,
      this.contentCreationButton,
      this.wrapListContents,
      this.noContentsToWrapMessage,
      this.actions})
      : super(key: key);

  final String pageTitle;
  final bool isContentLoading;
  final Widget? searchBar;
  final Widget? privacyFilterPanel;
  final Widget? downloadCentreContentPanel;
  final Widget? openVocePanel;
  final Widget? contentCreationButton;
  final List<Widget>? wrapListContents;
  final Widget? noContentsToWrapMessage;
  final List<Widget>? actions;

  bool _buildSearchBar() => searchBar != null;
  bool _buildPrivacyFilterPanel() => privacyFilterPanel != null;
  bool _buildDownloadCentreContentPanel() => downloadCentreContentPanel != null;
  bool _buildOpenVocePanel() => openVocePanel != null;
  bool _buildContentCreationButton() => contentCreationButton != null;
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
        actions: actions,
      ),
      body: isContentLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      if (_buildSearchBar())
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: media.height * .07,
                            width: media.width * .27,
                            child: searchBar,
                          ),
                        ),
                      if (_buildPrivacyFilterPanel() ||
                          _buildDownloadCentreContentPanel() ||
                          _buildOpenVocePanel())
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (_buildPrivacyFilterPanel())
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: privacyFilterPanel,
                                  ),
                                if (_buildDownloadCentreContentPanel())
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: downloadCentreContentPanel,
                                  ),
                                if (_buildOpenVocePanel())
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: openVocePanel,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(height: 10),
                      if (_buildContentCreationButton())
                        SizedBox(
                          width: media.width * .25,
                          child: contentCreationButton,
                        )
                    ],
                  ),
                  Spacer(),
                  Expanded(
                    flex: 15,
                    child: _buildWrap(context),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildWrap(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    if (_buildWrapListContents()) {
      if (wrapListContents!.isNotEmpty) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: media.width < 600 ? 1 : 2, // Numero di colonne
            mainAxisSpacing: 10.0, // Spazio verticale tra le righe
            crossAxisSpacing: 10.0,
            childAspectRatio: orientation == Orientation.landscape
                ? 6 / 3
                : media.width < 600
                    ? 8 / 3
                    : 7 / 3, // Spazio orizzontale tra le colonne
          ),
          itemBuilder: (context, index) => wrapListContents![index],
          itemCount: wrapListContents!.length,
        );
      } else {
        return SizedBox();
      }
    } else if (_buildNoContentsToWrap()) {
      return Center(
        child: noContentsToWrapMessage,
      );
    } else {
      return SizedBox();
    }
  }
}
