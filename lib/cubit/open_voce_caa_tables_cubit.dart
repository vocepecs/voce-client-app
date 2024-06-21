import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'open_voce_caa_tables_state.dart';

class OpenVoceCaaTablesCubit extends Cubit<OpenVoceCaaTablesState> {
  final VoceAPIRepository voceAPIRepository;
  final User user;
  List<CaaTable> caaTableList = List.empty(growable: true);
  List<CaaTable> mostUsedTables = List.empty(growable: true);
  late String text;
  OpenVoceCaaTablesCubit({
    required this.voceAPIRepository,
    required this.user,
  }) : super(OpenVoceCaaTablesInitial()) {
    getMostUsedTables();
  }

  void updatePattern(value) => text = value;

  void getMostUsedTables() async {
    try {
      List<Map<String, dynamic>> mostUsedTableData =
          await voceAPIRepository.getCaaTableList(
        searchMostUsed: true,
        userId: user.id,
      );
      mostUsedTables = List.from(mostUsedTableData.map(
        (e) => CaaTable.fromJson(e),
      ));
      emit(OpenVoceTablesLoaded(mostUsedTables, caaTableList));
    } on VoceApiException catch (_) {
      emit(OpenVoceTablesError());
    }
  }

  void getPublicTables() async {
    emit(OpenVoceTablesLoading(mostUsedTables));
    try {
      List<Map<String, dynamic>> caaTablesData =
          await voceAPIRepository.getCaaTableList(
        pattern: text,
      );
      caaTableList = List.from(caaTablesData.map(
        (e) => CaaTable.fromJson(e),
      ));
      if (caaTableList.isEmpty) {
        emit(OpenVoceTablesEmpty(mostUsedTables));
      } else {
        emit(OpenVoceTablesLoaded(mostUsedTables, caaTableList));
      }
    } on VoceApiException catch (_) {
      emit(OpenVoceTablesError());
    }
  }
}
