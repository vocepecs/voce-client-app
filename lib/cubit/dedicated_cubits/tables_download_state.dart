part of 'tables_download_cubit.dart';

@immutable
abstract class TablesDownloadState {}

class TablesDownloadInitial extends TablesDownloadState {}

class TablesDownloadLoading extends TablesDownloadState {}

class TablesDownloadDone extends TablesDownloadState {
  final List<CaaTable> caaTableList;
  TablesDownloadDone(this.caaTableList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TablesDownloadDone &&
        listEquals(other.caaTableList, caaTableList);
  }

  @override
  int get hashCode => caaTableList.hashCode;
}

class TablesDownloadError extends TablesDownloadState {}
