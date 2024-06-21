import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'download_public_tables_state.dart';

class DownloadPublicTablesCubit extends Cubit<DownloadPublicTablesState> {
  final VoceAPIRepository voceAPIRepository;
  String? _pattern;

  DownloadPublicTablesCubit({required this.voceAPIRepository})
      : super(DownloadPublicTablesInitial());

  void updatePattern(String value) => _pattern = value;

  void getPublicTables() async {
    emit(DownloadPublicTablesLoading());
    try {
      List<Map<String, dynamic>> caaTablesData =
          await voceAPIRepository.getCaaTableList(
        pattern: _pattern,
      );
      List<CaaTable> caaTableList = List.from(caaTablesData.map(
        (e) => CaaTable.fromJson(e),
      ));
      emit(DownloadPublicTablesDone(caaTableList));
    } on VoceApiException catch (_) {
      emit(DownloadPublicTablesError());
    }
  }
}
