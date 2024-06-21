part of 'download_centre_tables_cubit.dart';

@immutable
abstract class DownloadCentreTablesState {
  const DownloadCentreTablesState();
}

class DownloadCentreTablesInitial extends DownloadCentreTablesState {}

class DownloadCentreTablesLoading extends DownloadCentreTablesState {}

class DownloadCentreTablesDone extends DownloadCentreTablesState {
  final List<CaaTable> caaTableList;
  const DownloadCentreTablesDone(this.caaTableList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DownloadCentreTablesDone &&
        listEquals(other.caaTableList, caaTableList);
  }

  @override
  int get hashCode => caaTableList.hashCode;
}

class DownloadCentreTablesError extends DownloadCentreTablesState {}
