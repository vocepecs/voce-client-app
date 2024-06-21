part of 'download_public_tables_cubit.dart';

@immutable
abstract class DownloadPublicTablesState {
  const DownloadPublicTablesState();
}

class DownloadPublicTablesInitial extends DownloadPublicTablesState {}

class DownloadPublicTablesLoading extends DownloadPublicTablesState {}

class DownloadPublicTablesDone extends DownloadPublicTablesState {
  final List<CaaTable> caaTableList;
  const DownloadPublicTablesDone(this.caaTableList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DownloadPublicTablesDone &&
        listEquals(other.caaTableList, caaTableList);
  }

  @override
  int get hashCode => caaTableList.hashCode;
}

class DownloadPublicTablesError extends DownloadPublicTablesState {}
