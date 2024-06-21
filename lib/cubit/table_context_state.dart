part of 'table_context_cubit.dart';

@immutable
abstract class TableContextState {
  const TableContextState();
}

class TableContextLoading extends TableContextState {
  const TableContextLoading();
}

class TableContextLoaded extends TableContextState {
  final List<String> tableContextList;
  const TableContextLoaded(this.tableContextList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TableContextLoaded &&
        listEquals(other.tableContextList, tableContextList);
  }

  @override
  int get hashCode => tableContextList.hashCode;
}
