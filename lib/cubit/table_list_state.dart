part of 'table_list_cubit.dart';

@immutable
abstract class TableListState {
  const TableListState();
}

class TableListInitial extends TableListState {
  const TableListInitial();
}

class TableListLoaded extends TableListState {
  final List<CaaTable> caaTableList;
  const TableListLoaded(this.caaTableList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TableListLoaded &&
        listEquals(other.caaTableList, caaTableList);
  }

  @override
  int get hashCode => caaTableList.hashCode;
}

class TableListError extends TableListState {}
