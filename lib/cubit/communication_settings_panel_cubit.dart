import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'communication_settings_panel_state.dart';

class CommunicationSetupCubit extends Cubit<CommunicationSetupState> {
  final VoceAPIRepository voceAPIRepository;
  late List<CaaTable> _caaTableList;
  List<CaaTable>? _userTableList;
  List<CaaTable>? _defaultTableList;
  Patient? _activePatient;
  final User user;

  CommunicationSetupCubit({
    required this.voceAPIRepository,
    required this.user,
  }) : super(CommunicationSettingsPanelInitial()) {
    getData();
  }

  Patient? getActivePatient() {
    try {
      return user.patientList!.firstWhere((element) => element.isActive!);
    } catch (e) {
      return null;
    }
  }

  Future<void> getData() async {
    _activePatient = getActivePatient();

    if (_activePatient != null) {
      if (_activePatient!.tableList.isEmpty) {
        try {
          // Se non ci sono tabelle associate al paziente attivo scarico quelle generali associate all'utente
          List<Map<String, dynamic>> caaTablesData =
              await voceAPIRepository.getCaaTableList(
            userId: user.id,
            searchByOwner: true,
          );

          _userTableList = List.from(
            caaTablesData.map((e) => CaaTable.fromJson(e)),
          );

          // Se l'utente non ha tabelle associate scarico le tabelle di default fornite da VOCE
          if (_userTableList!.isEmpty) {
            List<dynamic> caaTablesData =
                await voceAPIRepository.getCaaTableList(
              searchDefault: true,
            );

            _defaultTableList = List.from(
              caaTablesData.map((e) => CaaTable.fromJson(e)),
            );
          }

          emit(
            CommunicationSetupLoaded(
              user.patientList!,
              _userTableList,
              _defaultTableList,
            ),
          );
        } on VoceApiException catch (_) {
          emit(CommunicationSetupError());
        }
      } else {
        emit(CommunicationSetupLoaded(
          user.patientList!,
          _userTableList,
          _defaultTableList,
        ));
      }
    } else {
      emit(CommuncationSetupNoActivePatient(user.patientList!));
    }
  }

  // ? Rimuovere
  bool existInactiveTables() =>
      _caaTableList.any((element) => element.isActive == false);
  // ? Rimuovere
  List<CaaTable> getInactiveTables() =>
      _caaTableList.where((element) => !element.isActive).toList();

  Future<void> setActivePatient(Patient patient) async {
    emit(CommunicationSettingsPanelInitial());

    user.patientList!.forEach((element) {
      element.isActive = false;
      if (element.id == patient.id) {
        element.isActive = true;
      }
    });

    try {
      voceAPIRepository.updateUser(user.toJson());
    } on VoceApiException catch (_) {
      emit(CommunicationSetupError());
    }

    getData();
  }

  void setActiveTable(CaaTable table) {
    emit(CommunicationSettingsPanelInitial());

    user.patientList!
        .firstWhere((element) => element.isActive!)
        .tableList
        .forEach((element) {
      element.isActive = false;
      if (element.id == table.id) {
        element.isActive = true;
      }
    });

    try {
      voceAPIRepository.updateUser(user.toJson());
    } on VoceApiException catch (_) {
      emit(CommunicationSetupError());
    }

    emit(CommunicationSetupEnded(table, _activePatient!));
  }

  void linkTableToPatient(CaaTable caaTable) async {
    caaTable.isPrivate = true;
    caaTable.isActive = true;

    try {
      Map<String, dynamic> tableCreatedData =
          await voceAPIRepository.createCaaTable(
        caaTable.toJson(),
        patientId: _activePatient!.id,
        originalTableId: caaTable.id,
        userId: user.id,
      );

      int tableId = tableCreatedData['caa_table_id'];
      Map<String, dynamic> tableData =
          await voceAPIRepository.getCaaTable(tableId);

      CaaTable newTable = CaaTable.fromJson(tableData);
      user.patientList!.forEach((element) {
        if (element.id == _activePatient!.id) {
          element.tableList.add(newTable);
        }
      });

      emit(CommunicationSetupEnded(newTable, _activePatient!));
    } on VoceApiException catch (_) {
      emit(CommunicationSetupError());
    }
  }
}
