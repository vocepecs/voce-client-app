part of 'table_filter_panel_cubit.dart';

@immutable
abstract class TableFilterPanelState {
  const TableFilterPanelState();
}

class TableFilterPanelInitial extends TableFilterPanelState {}

class TableFilterPanelLoading extends TableFilterPanelState {}

class TableFilterPanelUpdated extends TableFilterPanelState {
  final bool tableFilterPrivate;
  final bool tableFilterPublic;
  final bool tableFilterCentre;

  const TableFilterPanelUpdated(
    this.tableFilterPrivate,
    this.tableFilterPublic,
    this.tableFilterCentre,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TableFilterPanelUpdated &&
        other.tableFilterPrivate == tableFilterPrivate &&
        other.tableFilterPublic == tableFilterPublic &&
        other.tableFilterCentre == tableFilterCentre;
  }

  @override
  int get hashCode =>
      tableFilterPrivate.hashCode ^
      tableFilterPublic.hashCode ^
      tableFilterCentre.hashCode;
}
