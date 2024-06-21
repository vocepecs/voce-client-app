part of 'dash_patient_phrase_stats_cubit.dart';

@immutable
abstract class DashPatientPhraseStatsState {}

class DashPatientPhraseStatsInitial extends DashPatientPhraseStatsState {}

class DashPatientPhraseStatsloading extends DashPatientPhraseStatsState {}

class DashPatientPhraseStatsLoaded extends DashPatientPhraseStatsState {
  final List<Map<String,dynamic>> data;
  DashPatientPhraseStatsLoaded(this.data);

    @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashPatientPhraseStatsLoaded && listEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;

}
