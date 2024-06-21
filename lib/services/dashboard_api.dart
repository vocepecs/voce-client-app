import 'package:dio/dio.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/services/dio_manager.dart';

// * Dovrei usare un solo metodo di get per le statistiche
// * con gli stessi parametri di input, cambia solamente
// * la root della risorsa
class DashboardApi {
  final DioManager dio = DioManager();

  final String _resMostFrequentImages = "/most-frequent-images";
  final String _resMostFrequentContexts = "/context-frequency";
  final String _patientPhrasesStat = "/patient-phrases-stat";
  final String _distinctPictograms = "/distinct-pictograms";
  final String _grammaticalTypesUsage = "/grammatical-types-usage";

  Future<List<Map<String, dynamic>>?> getMostFrequentImages({
    int? patientId,
    int? centreId,
    required DateTime dateStart,
    required DateTime dateEnd,
  }) async {
    final String strDateStart = dateStart.toString().split(" ")[0];
    final String strDateEnd = dateEnd.toString().split(" ")[0];

    Response response = await dio.get(
      url: _resMostFrequentImages,
      parameters: {
        "date_start": strDateStart,
        "date_end": strDateEnd,
        "patient_id": patientId,
        "centre_id": centreId,
      },
    );

    List<Map<String, dynamic>>? result;

    if (response.statusCode == 200) {
      result = (response.data as List?)?.cast<Map<String, dynamic>>() ?? [];
      return result.length >= 10 ? result.sublist(0, 10) : result;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data ?? "Internal Server Error",
      );
    }
  }

  Future<List<Map<String, dynamic>>> getMostFrequentContexts({
    int? patientId,
    int? centreId,
    int? userId,
    required DateTime dateStart,
    required DateTime dateEnd,
  }) async {
    final String strDateStart = dateStart.toString().split(" ")[0];
    final String strDateEnd = dateEnd.toString().split(" ")[0];

    Response response = await dio.get(
      url: _resMostFrequentContexts,
      parameters: {
        "date_start": strDateStart,
        "date_end": strDateEnd,
        "patient_id": patientId,
        "centre_id": centreId,
        "user_id": userId,
      },
    );

    List<Map<String, dynamic>>? result;

    if (response.statusCode == 200) {
      result = (response.data as List?)?.cast<Map<String, dynamic>>() ?? [];
      return result.length >= 10 ? result.sublist(0, 10) : result;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data ?? "Internal Server Error",
      );
    }
  }

  Future<List<Map<String, dynamic>>> getPhraseStats({
    int? patientId,
    int? centreId,
    required DateTime dateStart,
    required DateTime dateEnd,
    bool weekView = false,
  }) async {
    final String strDateStart = dateStart.toString().split(" ")[0];
    final String strDateEnd = dateEnd.toString().split(" ")[0];

    Response response = await dio.get(
      url: _patientPhrasesStat,
      parameters: {
        "date_start": strDateStart,
        "date_end": strDateEnd,
        "patient_id": patientId,
        "centre_id": centreId,
        "week_view": weekView,
      },
    );

    List<Map<String, dynamic>>? result;

    if (response.statusCode == 200) {
      result = (response.data as List?)?.cast<Map<String, dynamic>>() ?? [];
      return result;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data ?? "Internal Server Error",
      );
    }
  }

  Future<List<Map<String, dynamic>>> getNewPictogramsStats({
    int? patientId,
    int? centreId,
    required DateTime dateStart,
    required DateTime dateEnd,
    bool weekView = false,
  }) async {
    final String strDateStart = dateStart.toString().split(" ")[0];
    final String strDateEnd = dateEnd.toString().split(" ")[0];

    Response response = await dio.get(
      url: _distinctPictograms,
      parameters: {
        "date_start": strDateStart,
        "date_end": strDateEnd,
        "patient_id": patientId,
        "centre_id": centreId,
        "week_view": weekView,
      },
    );

    List<Map<String, dynamic>>? result;

    if (response.statusCode == 200) {
      result = (response.data as List?)?.cast<Map<String, dynamic>>() ?? [];
      return result;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data ?? "Internal Server Error",
      );
    }
  }

  Future<List<Map<String, dynamic>>> getGrammaticalTypesStats({
    int? patientId,
    int? centreId,
    required DateTime dateStart,
    required DateTime dateEnd,
    bool weekView = false,
  }) async {
    final String strDateStart = dateStart.toString().split(" ")[0];
    final String strDateEnd = dateEnd.toString().split(" ")[0];

    Response response = await dio.get(
      url: _grammaticalTypesUsage,
      parameters: {
        "date_start": strDateStart,
        "date_end": strDateEnd,
        "patient_id": patientId,
        "centre_id": centreId,
        "week_view": weekView,
      },
    );

    List<Map<String, dynamic>>? result;

    if (response.statusCode == 200) {
      result = (response.data as List?)?.cast<Map<String, dynamic>>() ?? [];
      return result;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data ?? "Internal Server Error",
      );
    }
  }
}
