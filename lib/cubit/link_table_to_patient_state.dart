part of 'link_table_to_patient_cubit.dart';

@immutable
abstract class LinkTableToPatientState {
  const LinkTableToPatientState();
}

class LinkTableToPatientInitial extends LinkTableToPatientState {
  const LinkTableToPatientInitial();
}

class LinkTableToPatientLoading extends LinkTableToPatientState {
  const LinkTableToPatientLoading();
}

class LinkTableToPatientAddedTables extends LinkTableToPatientState {
  const LinkTableToPatientAddedTables();
}

class LinkTableToPatientLoaded extends LinkTableToPatientState {
  final List<CaaTable> caaTableList;
  const LinkTableToPatientLoaded(this.caaTableList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LinkTableToPatientLoaded &&
        listEquals(other.caaTableList, caaTableList);
  }

  @override
  int get hashCode => caaTableList.hashCode;
}

class LinkTableToPatientError extends LinkTableToPatientState {}
