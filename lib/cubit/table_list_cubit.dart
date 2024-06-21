import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'table_list_state.dart';

class TableListCubit extends Cubit<TableListState> {
  final VoceAPIRepository voceAPIRepository;
  late List<CaaTable> _caaTableList;

  TableListCubit({required this.voceAPIRepository}) : super(TableListInitial());

  void getAllTables() async {
    try {
      List<Map<String, dynamic>> caaTablesData =
          await voceAPIRepository.getCaaTableList();
      _caaTableList = List.from(caaTablesData.map((e) => CaaTable.fromJson(e)));
      emit(TableListLoaded(_caaTableList));
    } on VoceApiException catch (_) {
      emit(TableListError());
    }
  }
}
