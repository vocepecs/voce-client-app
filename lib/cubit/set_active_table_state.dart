part of 'set_active_table_cubit.dart';

@immutable
abstract class SetActiveTableState {
  const SetActiveTableState();
}

class SetActiveTableLoading extends SetActiveTableState {
  const SetActiveTableLoading();
}

class SetActiveTableLoaded extends SetActiveTableState {
  final List<CaaTable> tableList;
  const SetActiveTableLoaded(this.tableList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SetActiveTableLoaded &&
        listEquals(other.tableList, tableList);
  }

  @override
  int get hashCode => tableList.hashCode;
}

class SetActiveTableDone extends SetActiveTableState {
  const SetActiveTableDone();
}

class SetActiveTableError extends SetActiveTableState {}
