import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'table_context_state.dart';

class TableContextCubit extends Cubit<TableContextState> {
  final VoceAPIRepository voceAPIRepository;
  final setContextController = StreamController<String>();
  late List<String> _tableContextList;

  TableContextCubit({
    required this.voceAPIRepository,
  }) : super(TableContextLoading());

  //send data
  Stream<String> get onChangeContext => setContextController.stream;

  void getTableContexts() async {
    List<dynamic> contextData = await voceAPIRepository.getContextList();
    _tableContextList = List.from(contextData.map((e) => e['context_type']));
    emit(TableContextLoaded(_tableContextList));
  }

  List<String> getContextSuggestion(String query) {
    List<String> matches = <String>[];
    matches.addAll(_tableContextList);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  void selectContext(String value) {
    setContextController.sink.add(value);
  }

  Future<void> close() {
    setContextController.close();
    return super.close();
  }
}
