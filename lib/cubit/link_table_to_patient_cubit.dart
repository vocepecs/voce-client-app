import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'link_table_to_patient_state.dart';

class LinkTableToPatientCubit extends Cubit<LinkTableToPatientState> {
  final VoceAPIRepository voceAPIRepository;
  final User user;
  late List<CaaTable> _caaTableList;
  late List<SelectableItem> _selectableItemList = [];
  final Patient patient;
  late bool _privateFilter;
  late bool _centreFilter;
  late bool _publicFilter;

  LinkTableToPatientCubit({
    required this.voceAPIRepository,
    required this.patient,
    required this.user,
  }) : super(LinkTableToPatientInitial()) {
    _privateFilter = true;
    _centreFilter = true;
    _publicFilter = true;
  }

  void updateFilters(
    bool privateFilter,
    bool centreFilter,
    bool publicFilter,
  ) {
    _privateFilter = privateFilter;
    _centreFilter = centreFilter;
    _publicFilter = publicFilter;
    _filterTables();
  }

  void getUserTables() async {
    emit(LinkTableToPatientLoading());
    try {
      List<Map<String, dynamic>> caaTablesData =
          await voceAPIRepository.getCaaTableList(
        userId: user.id,
        searchByOwner: true,
        searchDefault: true,
      );
      _caaTableList = List.from(caaTablesData.map((e) => CaaTable.fromJson(e)));
      _caaTableList.removeWhere((caaTable) => patient.tableList
          .map((patientTable) => patientTable.id)
          .toList()
          .contains(caaTable.id));

      _caaTableList.forEach((element) {
        _selectableItemList.add(SelectableItem(caaTable: element));
      });

      _filterTables();
    } on VoceApiException catch (_) {
      emit(LinkTableToPatientError());
    }
  }

  void updateTableList(List<CaaTable> caaTableList) async {
    emit(LinkTableToPatientLoading());

    caaTableList.removeWhere((element) =>
        _caaTableList.map((e) => e.id).toList().contains(element.id));

    _caaTableList.addAll(caaTableList);

    _caaTableList.removeWhere((caaTable) => patient.tableList
        .map((patientTable) => patientTable.id)
        .toList()
        .contains(caaTable.id));

    _caaTableList.forEach((element) {
      _selectableItemList.add(SelectableItem(caaTable: element));
    });

    _filterTables();
  }

  void _filterTables() {
    List<CaaTable> filteredTableList = List.from(_caaTableList);

    if (_privateFilter == false) {
      filteredTableList.removeWhere((element) => element.isPrivate);
    }
    if (_centreFilter == false) {
      filteredTableList
          .removeWhere((element) => element.autismCentreId != null);
    }
    if (_publicFilter == false) {
      filteredTableList.removeWhere(
          (element) => element.autismCentreId == null && !element.isPrivate);
    }

    emit(LinkTableToPatientLoaded(filteredTableList));
  }

  void updateSelectableItemList(CaaTable caaTable, bool value) {
    _selectableItemList.forEach((element) {
      if (element.caaTable.id == caaTable.id) {
        element.isSelected = value;
      }
    });
  }

  void linkTableToPatient() async {
    List<CaaTable> selectedTables = _selectableItemList
        .where((element) => element.isSelected)
        .map((e) => e.caaTable)
        .toList();

    try {
      selectedTables.forEach((element) async {
        element.isPrivate = true;

        await voceAPIRepository.createCaaTable(
          element.toJson(),
          patientId: patient.id,
          originalTableId: element.id,
          userId: user.id,
        );
      });

      Future.delayed(Duration(milliseconds: 500),
          () => emit(LinkTableToPatientAddedTables()));
    } on VoceApiException catch (_) {
      emit(LinkTableToPatientError());
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
