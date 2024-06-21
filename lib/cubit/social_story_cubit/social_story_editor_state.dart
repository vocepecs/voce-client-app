part of 'social_story_editor_cubit.dart';

@immutable
abstract class SocialStoryEditorState {}

class SocialStoryEditorInitial extends SocialStoryEditorState {}

class SocialStoryEditorLoading extends SocialStoryEditorState {}

class SocialStoryTranslationLoading extends SocialStoryEditorState {}

class SocialStoryPersonalImagesWarning extends SocialStoryEditorState {}

class SocialStoryEditorLoaded extends SocialStoryEditorState {
  final SocialStory socialStory;
  SocialStoryEditorLoaded(this.socialStory);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SocialStoryEditorLoaded && other.socialStory == socialStory;
  }

  @override
  int get hashCode => socialStory.hashCode;
}

class SocialStoryEditorImagesNotFound extends SocialStoryEditorState {
  final int comunicativeSessionId;
  final Map<String, List<CaaImage>> imageCorrectionList;
  SocialStoryEditorImagesNotFound(
    this.comunicativeSessionId,
    this.imageCorrectionList,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SocialStoryEditorImagesNotFound &&
        other.comunicativeSessionId == comunicativeSessionId &&
        mapEquals(other.imageCorrectionList, imageCorrectionList);
  }

  @override
  int get hashCode =>
      comunicativeSessionId.hashCode ^ imageCorrectionList.hashCode;
}

class SocialStoryEditorUpdateDone extends SocialStoryEditorState {}

class SocialStoryEditorDuplicateDone extends SocialStoryEditorState {}

class SocialStoryEditorCreateDone extends SocialStoryEditorState {}

class SocialStoryEditorDeleteDone extends SocialStoryEditorState {}

class SocialStoryEditorContenateUnavailable extends SocialStoryEditorState {}

class SocialStoryEditorTranslationError extends SocialStoryEditorState {}

class SocialStoryEditorError extends SocialStoryEditorState {}
