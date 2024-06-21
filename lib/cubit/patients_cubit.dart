import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'patients_state.dart';

class PatientsCubit extends Cubit<PatientsState> {
  final VoceAPIRepository voceAPIRepository;
  late List<Patient> _patientList;

  PatientsCubit({
    required this.voceAPIRepository,
  }) : super(PatientsInitial());

  Future<void> getPatients() async {
    ///TODO IMPLEMENTA METODO PER RECUPERO PAZIENTI DELL'OPERATORE
    ///USA GET IT PACKAGE
  }

  List<Patient> filterPatientByName(String query) {
    List<Patient> matches = <Patient>[];
    matches.addAll(_patientList);
    matches.retainWhere((patient) =>
        patient.nickname.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
