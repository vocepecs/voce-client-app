import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/models/autism_centre.dart';
import 'package:voce/services/voce_api_repository.dart';

part 'sign_up_centre_panel_state.dart';

class SignUpCentrePanelCubit extends Cubit<SignUpCentrePanelState> {
  late List<AutismCentre> _autismCentreList;
  late String _autismCentreCode;
  AutismCentre? _autismCentreSelected;
  final VoceAPIRepository voceAPIRepository;

  SignUpCentrePanelCubit({required this.voceAPIRepository})
      : super(SignUpCentrePanelInitial());

  void updateAutsimCentreCode(String value) => _autismCentreCode = value;

  Future<void> getCentres() async {
    try {
      List<Map<String, dynamic>> centreListData =
          await voceAPIRepository.getAutismCentreList();
      _autismCentreList =
          List.from(centreListData.map((e) => AutismCentre.fromJson(e)));
      emit(SignUpCentrePanelLoaded(_autismCentreList));
    } on VoceApiException catch (_) {
      emit(SignUpCentrePanelError());
    }
  }

  Future<void> verifyAutismCentreCode(int id) async {
    try {
      await voceAPIRepository.verifyAutismCentreCode(
        _autismCentreCode,
        id,
      );
      emit(SecretCodeCorrect());
    } on VoceApiException catch (error) {
      if (error.statusCode == 400) {
        emit(SecretCodeIncorrect());
      } else {
        emit(SignUpCentrePanelError());
      }
    }
  }
}
