import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'table_filter_panel_state.dart';

class TableFilterPanelCubit extends Cubit<TableFilterPanelState> {
  bool _privateFilter = true;
  bool _centreFilter = true;
  bool _publicFilter = true;

  TableFilterPanelCubit() : super(TableFilterPanelInitial());

  void updatePrivateFilter(bool value) {
    _privateFilter = value;
    emitUpdate();
  }

  void updateCentreFilter(bool value) {
    _centreFilter = value;
    emitUpdate();
  }

  void updatePublicFilter(bool value) {
    _publicFilter = value;
    emitUpdate();
  }

  void emitUpdate() {
    emit(TableFilterPanelLoading());
    emit(TableFilterPanelUpdated(
      _privateFilter,
      _publicFilter,
      _centreFilter,
    ));
  }
}
