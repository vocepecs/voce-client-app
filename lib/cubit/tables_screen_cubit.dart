import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'tables_screen_state.dart';

class TablesScreenCubit extends Cubit<TablesScreenState> {
  final VoceAPIRepository voceAPIRepository;
  final User user;
  late List<CaaTable> _caaTableList;
  List<CaaTable> _filteredCaaTable = List.empty(growable: true);
  late bool _privateFilter;
  late bool _centreFilter;
  late bool _publicFilter;
  String searchText = "";

  TablesScreenCubit({
    required this.voceAPIRepository,
    required this.user,
  }) : super(TablesScreenLoading()) {
    _privateFilter = true;
    _centreFilter = true;
    _publicFilter = true;
  }

  void updateSearchText(String value) {
    searchText = value;
    _filterByPattern();
  }

  void _filterByPattern() {
    emit(TablesScreenLoading());
    if (searchText.isNotEmpty) {
      _filteredCaaTable = _caaTableList
          .where((element) =>
              element.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
    _applyFilters();
  }

  void updateFilterPrivate(bool value) {
    emit(TablesScreenLoading());
    _privateFilter = value;
    _applyFilters();
  }

  void updateFilterPublic(bool value) {
    emit(TablesScreenLoading());
    _publicFilter = value;
    _applyFilters();
  }

  void updateFilterCentre(bool value) {
    emit(TablesScreenLoading());
    _centreFilter = value;
    _applyFilters();
  }

  void emitLoadingState() => emit(TablesScreenLoading());

  void _applyFilters() {
    List<CaaTable> filteredTableList =
        List.from(searchText.isNotEmpty ? _filteredCaaTable : _caaTableList);

    if (_privateFilter == false) {
      filteredTableList.removeWhere(
          (element) => element.isPrivate && element.autismCentreId == null);
    }

    if (_centreFilter == false) {
      filteredTableList
          .removeWhere((element) => element.autismCentreId != null);
    }

    if (_publicFilter == false) {
      filteredTableList.removeWhere(
          (element) => element.autismCentreId == null && !element.isPrivate);
    }

    emit(TablesScreenLoaded(filteredTableList));
  }

  void getUserTables() async {
    // emit(TablesScreenLoading());
    try {
      List<Map<String, dynamic>> caaTablesData =
          await voceAPIRepository.getCaaTableList(
        userId: user.id,
        searchByOwner: true,
      );

      _caaTableList = List.from(caaTablesData.map((e) => CaaTable.fromJson(e)));
      if (_caaTableList.isEmpty) {
        emit(NoPrivateTableExists());
      } else {
        _applyFilters();
      }
    } on VoceApiException catch (_) {
      emit(TablesScreenError());
    }
  }

  void updateTableList(List<CaaTable> caaTableList) async {
    emit(TablesScreenLoading());

    caaTableList.removeWhere((element) =>
        _caaTableList.map((e) => e.id).toList().contains(element.id));
    _caaTableList.addAll(caaTableList);

    _applyFilters();
  }

  void getCentreTables() async {
    emit(TablesScreenLoading());
    try {
      List<Map<String, dynamic>> caaTablesData =
          await voceAPIRepository.getCaaTableList(
        autismCentreId: user.autismCentre!.id,
      );

      List<CaaTable> caaTableList =
          List.from(caaTablesData.map((e) => CaaTable.fromJson(e)));
      _caaTableList.addAll(caaTableList);
      _applyFilters();
    } on VoceApiException catch (_) {
      emit(TablesScreenError());
    }
  }

  void linkTableToPatients(
    List<int> patientSelected,
    CaaTable tableSelected,
  ) async {
    emit(TablesScreenLoading());

    if (patientSelected.isNotEmpty) {
      for (var i = 0; i < user.patientList!.length; i++) {
        if (patientSelected.contains(i)) {
          try {
            tableSelected.isPrivate = true;

            await voceAPIRepository.createCaaTable(
              tableSelected.toJson(),
              patientId: user.patientList![i].id,
              originalTableId: tableSelected.id,
              userId: user.id,
            );
          } on VoceApiException catch (_) {
            emit(TablesScreenError());
          }
        }
      }
      Future.delayed(
        Duration(milliseconds: 500),
        () => emit(TableAddedToPatients()),
      );
    }
  }
}
