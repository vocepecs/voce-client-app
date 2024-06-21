import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'set_active_table_state.dart';

class SetActiveTableCubit extends Cubit<SetActiveTableState> {
  final VoceAPIRepository voceAPIRepository;
  late List<SelectableItem> _selectableItemList = [];
  late List<CaaTable> _tableList;
  final Patient patient;

  SetActiveTableCubit({
    required this.voceAPIRepository,
    required this.patient,
  }) : super(SetActiveTableLoading());

  void createSelectableItemList() {
    patient.tableList.forEach((element) {
      _selectableItemList.add(SelectableItem(caaTable: element));
    });
    emit(SetActiveTableLoaded(patient.tableList));
  }

  void setActiveTable() async {
    int tableId = _selectableItemList
        .firstWhere((element) => element.isSelected)
        .caaTable
        .id!;
    try {
      await voceAPIRepository.setActiveCaaTable(tableId, patient.id!);
    } on VoceApiException catch (_) {
      emit(SetActiveTableError());
    }
  }

  void updateSelectableItemList(CaaTable caaTable, bool value) {
    if (value == true) {
      if (_selectableItemList.every((element) => element.isSelected == false)) {
        _selectableItemList.forEach((element) {
          if (element.caaTable.id == caaTable.id) {
            element.isSelected = value;
          }
        });
      }
    } else {
      _selectableItemList.forEach((element) {
        if (element.caaTable.id == caaTable.id) {
          element.isSelected = value;
        }
      });
    }
  }
}

class SelectableItem {
  final CaaTable caaTable;
  bool isSelected;

  SelectableItem({
    required this.caaTable,
    this.isSelected = false,
  });
}
