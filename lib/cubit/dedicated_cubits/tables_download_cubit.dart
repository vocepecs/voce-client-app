import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'tables_download_state.dart';

class TablesDownloadCubit extends Cubit<TablesDownloadState> {
  final VoceAPIRepository voceAPIRepository;
  late User _user;
  List<CaaTable>? _caaTableList;
  TablesDownloadCubit({required this.voceAPIRepository})
      : super(TablesDownloadInitial());

  User get user => _user;
  set user(value) => _user = value;

  void getTables() async {
    emit(TablesDownloadLoading());
    try {
      List<Map<String, dynamic>> caaTablesData =
          await voceAPIRepository.getCaaTableList(
        searchDefault: true,
      );
      _caaTableList = List.from(caaTablesData.map((e) => CaaTable.fromJson(e)));
      emit(TablesDownloadDone(_caaTableList!));
    } on VoceApiException catch (_) {
      emit(TablesDownloadError());
    }
  }
}
