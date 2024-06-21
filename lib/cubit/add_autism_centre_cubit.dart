import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/autism_centre.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'add_autism_centre_state.dart';

class AddAutismCentreCubit extends Cubit<AddAutismCentreState> {
  final VoceAPIRepository voceAPIRepository;
  late String _autismCentreName;
  late String _autismCentreAddress;

  AddAutismCentreCubit({
    required this.voceAPIRepository,
  }) : super(AddAutismCentreInitial());

  void updateAutismCentreName(String value) => _autismCentreName = value;
  void updateAutismCentreAddress(String value) => _autismCentreAddress = value;

  Future<void> createAutismCentre() async {
    emit(AddAutismCentreLoading());
    final autismCentre = AutismCentre.createNew(
      _autismCentreName,
      _autismCentreAddress,
    );

    try {
      Map<String, dynamic> responseData =
          await voceAPIRepository.createAutismCentre(
        autismCentre.toJson(),
      );

      emit(AutismCentreCreated(responseData['secret_code']));
    } on VoceApiException catch (_) {
      emit(AddAutismCentreError());
    }
  }
}
