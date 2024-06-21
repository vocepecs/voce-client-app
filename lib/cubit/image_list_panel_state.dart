part of 'image_list_panel_cubit.dart';

@immutable
abstract class ImageListPanelState {
  const ImageListPanelState();
}

class ImageListPanelInitial extends ImageListPanelState {
  const ImageListPanelInitial();
}

class ImageListPanelLoading extends ImageListPanelState {
  ImageListPanelLoading();
}

class ImageListPanelLoaded extends ImageListPanelState {
  final List<CaaImage> imageList;
  ImageListPanelLoaded(this.imageList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageListPanelLoaded &&
        listEquals(other.imageList, imageList);
  }

  @override
  int get hashCode => imageList.hashCode;
}

class ImageListPanelError extends ImageListPanelState {
  ImageListPanelError();
}
