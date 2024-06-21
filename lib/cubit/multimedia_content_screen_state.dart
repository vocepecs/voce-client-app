part of 'multimedia_content_screen_cubit.dart';

@immutable
abstract class MultimediaContentScreenState {
  const MultimediaContentScreenState();
}

class MultimediaContentScreenInitial extends MultimediaContentScreenState {
  const MultimediaContentScreenInitial();
}

class MultimediaContentScreenLoading extends MultimediaContentScreenState {
  const MultimediaContentScreenLoading();
}

class MultimediaContentScreenLoaded extends MultimediaContentScreenState {
  final List<CaaMultimediaContent> multimediaContentList;
  const MultimediaContentScreenLoaded(this.multimediaContentList);
}

class MultimediaContentScreenError extends MultimediaContentScreenState {
  const MultimediaContentScreenError();
}
