import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/user.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'download_centre_tables_state.dart';

class DownloadCentreTablesCubit extends Cubit<DownloadCentreTablesState> {
  final VoceAPIRepository voceAPIRepository;
  final User user;

  DownloadCentreTablesCubit({
    required this.voceAPIRepository,
    required this.user,
  }) : super(DownloadCentreTablesInitial());

  void getCentreTables() async {
    emit(DownloadCentreTablesLoading());

    try {
      List<Map<String, dynamic>> caaTablesData =
          await voceAPIRepository.getCaaTableList(
        autismCentreId: user.autismCentre!.id,
      );

      List<CaaTable> caaTableList = List.from(caaTablesData.map(
        (e) => CaaTable.fromJson(e),
      ));

      emit(DownloadCentreTablesDone(caaTableList));
    } on VoceApiException catch (_) {
      emit(DownloadCentreTablesError());
    }
  }
}
