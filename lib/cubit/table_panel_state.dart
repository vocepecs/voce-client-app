part of 'table_panel_cubit.dart';

@immutable
abstract class TablePanelState {
  const TablePanelState();
}

class TablePanelInitial extends TablePanelState {
  const TablePanelInitial();
}

class TablePanelLoading extends TablePanelState {
  const TablePanelLoading();
}

class TableCreated extends TablePanelState {
  const TableCreated();
}

class TableUpdated extends TablePanelState {
  const TableUpdated();
}

class TableUpdateError extends TablePanelState {
  const TableUpdateError();
}

class TableDeleted extends TablePanelState {}

class TableDeletionError extends TablePanelState {}

class TableDuplicated extends TablePanelState {}

class TableCreationError extends TablePanelState {
  const TableCreationError();
}

class TablePanelPersonalImagesWarning extends TablePanelState {}

// Usato per errori sul processo di salvataggio della tabelle sia Update che Creation
class TablePanelError extends TablePanelState {}

class TablePanelLoaded extends TablePanelState {
  final CaaTable caaTable;
  const TablePanelLoaded(this.caaTable);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TablePanelLoaded && other.caaTable == caaTable;
  }

  @override
  int get hashCode => caaTable.hashCode;
}
