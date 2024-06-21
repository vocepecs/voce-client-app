part of 'open_voce_caa_tables_cubit.dart';

@immutable
abstract class OpenVoceCaaTablesState {
  final List<CaaTable> mostUsedTables;
  OpenVoceCaaTablesState({this.mostUsedTables = const []});
}

class OpenVoceCaaTablesInitial extends OpenVoceCaaTablesState {}

class OpenVoceTablesLoading extends OpenVoceCaaTablesState {
  final List<CaaTable> mostUsedTables;
  OpenVoceTablesLoading(this.mostUsedTables);
}

class OpenVoceTablesLoaded extends OpenVoceCaaTablesState {
  final List<CaaTable> mostUsedTables;
  final List<CaaTable> caaTableList;
  OpenVoceTablesLoaded(this.mostUsedTables, this.caaTableList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OpenVoceTablesLoaded &&
        listEquals(other.mostUsedTables, mostUsedTables) &&
        listEquals(other.caaTableList, caaTableList);
  }

  @override
  int get hashCode => mostUsedTables.hashCode ^ caaTableList.hashCode;
}

class OpenVoceTablesEmpty extends OpenVoceCaaTablesState {
  final List<CaaTable> mostUsedTables;
  OpenVoceTablesEmpty(this.mostUsedTables);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OpenVoceTablesEmpty &&
        listEquals(other.mostUsedTables, mostUsedTables);
  }

  @override
  int get hashCode => mostUsedTables.hashCode;
}

class OpenVoceTablesError extends OpenVoceCaaTablesState {}
