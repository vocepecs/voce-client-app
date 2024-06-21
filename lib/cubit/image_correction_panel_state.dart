part of 'image_correction_panel_cubit.dart';

@immutable
abstract class ImageCorrectionPanelState {
  const ImageCorrectionPanelState();
}

class ImageCorrectionPanelInitial extends ImageCorrectionPanelState {
  const ImageCorrectionPanelInitial();
}

class ImageCorrectionPanelLoaded extends ImageCorrectionPanelState {
  final List<CaaImage> suggestedImages;
  final CaaImage image;
  ImageCorrectionPanelLoaded(
    this.image,
    this.suggestedImages,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageCorrectionPanelLoaded &&
        listEquals(other.suggestedImages, suggestedImages) &&
        other.image == image;
  }

  @override
  int get hashCode => suggestedImages.hashCode ^ image.hashCode;
}

class ImageCorrectionPanelError extends ImageCorrectionPanelState {}
