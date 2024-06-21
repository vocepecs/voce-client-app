part of 'communication_settings_panel_cubit.dart';

@immutable
abstract class CommunicationSetupState {
  const CommunicationSetupState();
}

class CommunicationSettingsPanelInitial extends CommunicationSetupState {
  const CommunicationSettingsPanelInitial();
}

class CommunicationSetupLoading extends CommunicationSetupState {}

class CommuncationSetupNoActivePatient extends CommunicationSetupState {
  final List<Patient> patientList;
  const CommuncationSetupNoActivePatient(this.patientList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommuncationSetupNoActivePatient &&
        listEquals(other.patientList, patientList);
  }

  @override
  int get hashCode => patientList.hashCode;
}

class CommunicationSetupLoaded extends CommunicationSetupState {
  final List<Patient> patientList;
  final List<CaaTable>? userCaaTables;
  final List<CaaTable>? defaultCaaTables;
  const CommunicationSetupLoaded(
    this.patientList,
    this.userCaaTables,
    this.defaultCaaTables,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommunicationSetupLoaded &&
        listEquals(other.patientList, patientList) &&
        listEquals(other.userCaaTables, userCaaTables) &&
        listEquals(other.defaultCaaTables, defaultCaaTables);
  }

  @override
  int get hashCode =>
      patientList.hashCode ^ userCaaTables.hashCode ^ defaultCaaTables.hashCode;
}

class CommunicationSetupEnded extends CommunicationSetupState {
  final CaaTable activeTable;
  final Patient activePatient;
  CommunicationSetupEnded(this.activeTable, this.activePatient);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommunicationSetupEnded &&
        other.activeTable == activeTable &&
        other.activePatient == activePatient;
  }

  @override
  int get hashCode => activeTable.hashCode ^ activePatient.hashCode;
}

class CommunicationSetupError extends CommunicationSetupState {}
