part of 'pictograms_cubit.dart';

@immutable
abstract class PictogramsState {}

class PictogramsInitial extends PictogramsState {}

class PictogramsLoading extends PictogramsState {}

class PictogramsLoaded extends PictogramsState {
  final List<CaaImage> pictogramList;

  PictogramsLoaded(this.pictogramList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PictogramsLoaded &&
        listEquals(other.pictogramList, pictogramList);
  }

  @override
  int get hashCode => pictogramList.hashCode;
}

class PictogramsNotFound extends PictogramsState {}

class PictogramsError extends PictogramsState {}

class PictogramDeleted extends PictogramsState {}

class PictogramDeleteError extends PictogramsState {}
