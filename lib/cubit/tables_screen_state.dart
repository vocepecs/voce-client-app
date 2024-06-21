part of 'tables_screen_cubit.dart';

@immutable
abstract class TablesScreenState {
  const TablesScreenState();
}

class TablesScreenLoading extends TablesScreenState {
  const TablesScreenLoading();
}

class NoPrivateTableExists extends TablesScreenState {}

class TablesScreenLoaded extends TablesScreenState {
  final List<CaaTable> caaTableList;
  const TablesScreenLoaded(this.caaTableList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TablesScreenLoaded &&
        listEquals(other.caaTableList, caaTableList);
  }

  @override
  int get hashCode => caaTableList.hashCode;
}

class TablesScreenError extends TablesScreenState {}

class TableAddedToPatients extends TablesScreenState {}
