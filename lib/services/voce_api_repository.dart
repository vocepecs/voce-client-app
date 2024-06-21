import 'package:dio/dio.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/services/dio_manager.dart';

class VoceAPIRepository {
  final DioManager dio = DioManager();

  final _resUser = "/user";
  final _resPatient = "/patient";
  final _resAutismCentre = "/autism-centre";

  final _resCaaTableList = "/caa-tables";
  final _resCaaTable = "/caa-table";

  final _resImageList = "/images";
  final _resImage = "/image";
  final _resContextList = "/all-contexts";

  final _resSearch = "/search";
  final _resTranslateV2 = "/translate_v2";
  final _resSuggestedV2 = "/search-suggested2";

  final _resCsOuputImage = "/cs_output_image";
  final _resSocialStories = "/social-stories";
  final _resSocialStory = "/social-story";

  final _resPatientCsLog = "/patient-cs-logs";
  final _resCsOutputPushImage = "/add-cs-output-image";

  final _resResetPassword = "/password-reset";

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> data) async {
    Response response = await dio.post(url: _resUser, body: data);
    if (response.statusCode == 201) {
      return response.data["user"];
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> getUser(int userId) async {
    Response response =
        await dio.get(url: _resUser, parameters: {"user_id": userId});
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> data) async {
    Response response = await dio.put(url: _resUser, body: data);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
        data: response.data,
      );
    }
  }

  Future<Map<String, dynamic>> createAutismCentre(
    Map<String, dynamic> data,
  ) async {
    Response response = await dio.post(
      url: _resAutismCentre,
      body: data,
    );

    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<List<Map<String, dynamic>>> getAutismCentreList() async {
    Response response = await dio.get(url: '$_resAutismCentre/all-centres');

    if (response.statusCode == 200) {
      return (response.data["autism_centres"] as List<dynamic>)
          .cast<Map<String, dynamic>>();
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> verifyAutismCentreCode(
    String secretCode,
    int centreId,
  ) async {
    String url = "$_resAutismCentre/verify-code";

    Map<String, dynamic> data = {
      "secret_code": secretCode,
      "centre_id": centreId,
    };

    Response response = await dio.post(
      url: url,
      body: data,
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<List<Map<String, dynamic>>> getImageList({
    int? userId,
    bool? searchUserImages,
  }) async {
    Map<String, dynamic> parameters = {
      "user_id": userId,
      "search_user_images": searchUserImages,
    };
    Response response = await dio.get(
      url: _resImageList,
      parameters: parameters,
    );

    if (response.statusCode == 200) {
      return (response.data["caa_images"] as List<dynamic>)
          .cast<Map<String, dynamic>>();
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> deleteImage(int imageId) async {
    Response response = await dio.delete(
      url: _resImage,
      parameters: {
        "image_id": imageId,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> editImage({
    required int imageId,
    required Map<String, dynamic> data,
  }) async {
    Response response = await dio.put(
      url: _resImage,
      parameters: {
        "image_id": imageId,
      },
      body: data,
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<List<Map<String, dynamic>>> getCaaTableList({
    String? pattern,
    int? userId,
    int? autismCentreId,
    bool? searchByOwner,
    bool? searchDefault,
    bool? searchMostUsed,
  }) async {
    Map<String, dynamic> parameters = {
      "pattern": pattern,
      "user_id": userId,
      "autism_centre_id": autismCentreId,
      "search_by_owner": searchByOwner,
      "search_default": searchDefault,
      "search_most_used": searchMostUsed,
    };

    Response response = await dio.get(
      url: _resCaaTableList,
      parameters: parameters,
    );
    if (response.statusCode == 200) {
      return (response.data["caa_tables"] as List<dynamic>)
          .cast<Map<String, dynamic>>();
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> getCaaTable(int caaTableId) async {
    Response response = await dio.get(
      url: _resCaaTable,
      parameters: {
        "caa_table_id": caaTableId,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> deleteCaaTable(int caaTableId) async {
    Response response = await dio.delete(
      url: _resCaaTable,
      parameters: {
        "caa_table_id": caaTableId,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  // TODO Rimuovere e sostituire lato client con il metodo di update di caaTable
  Future<Map<String, dynamic>> setActiveCaaTable(
      int caaTableId, int patientId) async {
    Response response = await dio.post(
      url: "$_resCaaTable/active-caa-table",
      parameters: {
        "caa_table_id": caaTableId,
        "patient_id": patientId,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<List<Map<String, dynamic>>> getContextList() async {
    Response response = await dio.get(
      url: _resContextList,
    );

    if (response.statusCode == 200) {
      return response.data["context_list"];
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> setActivePatient(
    int userId,
    int patientId,
  ) async {
    final url = "$_resPatient/active-patient";
    Response response = await dio.post(
      url: url,
      parameters: {
        "user_id": userId,
        "patient_id": patientId,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data["message"] ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> getPatient(int patientId) async {
    Response response = await dio.get(
      url: _resPatient,
      parameters: {
        "patient_id": patientId,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> createCaaTable(
    Map<String, dynamic> data, {
    int? patientId,
    int? userId,
    int? originalTableId,
  }) async {
    Response response = await dio.post(
      url: _resCaaTable,
      body: data,
      parameters: {
        "patient_id": patientId,
        "user_id": userId,
        "original_table_id": originalTableId,
      },
    );

    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> createCustomImage(
    Map<String, dynamic> data, {
    int? imageId,
    String? correctionLabel,
  }) async {
    Response response = await dio.post(
      url: _resImage,
      parameters: {
        "image_type": "custom_image",
        "image_id": imageId,
        "correction_label": correctionLabel,
      },
      body: data,
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data["message"] ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> addImageToPatients(
    Map<String, dynamic> data,
    int imageId,
  ) async {
    final url = "$_resPatient/add-image";

    Response response = await dio.post(
      url: url,
      parameters: {
        "image_id": imageId,
      },
      body: data,
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data["message"] ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> updateCaaTable(
    Map<String, dynamic> data,
    int tableId,
  ) async {
    Response response = await dio.put(
      url: _resCaaTable,
      body: data,
      parameters: {
        "caa_table_id": tableId,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data["message"] ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> createPatient(
    Map<String, dynamic> data,
    int userId,
  ) async {
    Response response = await dio.post(
      url: _resPatient,
      body: data,
      parameters: {
        "user_id": userId,
      },
    );

    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data["message"] ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> updatePatient(
    Map<String, dynamic> data,
    int patientId,
  ) async {
    final uriPatient = Uri.parse('$_resPatient?patient_id=$patientId');

    Response response = await dio.put(
      url: uriPatient.toString(),
      body: data,
      parameters: {
        "patient_id": patientId,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data["message"] ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> enrollPatient(
    int userId,
    int patientId,
  ) async {
    final url = "$_resPatient/enroll-patient";
    Response response = await dio.post(
      url: url,
      parameters: {
        "user_id": userId,
        "patient_id": patientId,
      },
    );

    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data["message"] ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> translatePhraseV2(
    Map<String, dynamic> data,
    int? tableId,
    int? userId,
    int? patientId,
  ) async {
    Response response = await dio.post(
      url: _resTranslateV2,
      body: data,
      parameters: {
        "id_table": tableId,
        "id_user": userId,
        "id_patient": patientId,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else if (response.statusCode == 404) {
      throw VoceApiException(
        response.statusCode!,
        response.data["message"] ?? "Internal Server Error",
        data: response.data,
      );
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data["message"] ?? "Internal Server Error",
        data: response.data,
      );
    }
  }

  Future<List<Map<String, dynamic>>> searchSuggestedImagesV2Post(
      Map<String, dynamic> data) async {
    final uriSearch = Uri.parse('$_resSuggestedV2');

    Response response = await dio.post(
      url: uriSearch.toString(),
      body: data,
    );

    if (response.statusCode == 200) {
      return (response.data["suggested"] as List<dynamic>)
          .cast<Map<String, dynamic>>();
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data["message"] ?? "Internal Server Error",
      );
    }
  }

  Future<List<Map<String, dynamic>>> searchImages(
    Map<String, dynamic> data, {
    String? searchType,
  }) async {
    Response response = await dio.post(
      url: _resSearch,
      body: data,
      parameters: {
        "search_type": searchType,
      },
    );

    if (response.statusCode == 200) {
      return (response.data["caa_images"] as List<dynamic>)
          .cast<Map<String, dynamic>>();
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data["message"] ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> updateCsOutputImage({
    int? oldImageId,
    int? newImageId,
    required int comunicativeSessionId,
    Map<String, dynamic>? data,
  }) async {
    Response response =
        await dio.post(url: _resCsOuputImage, body: data, parameters: {
      "image_id": oldImageId,
      "new_image_id": newImageId,
      "cs_id": comunicativeSessionId,
    });

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.data["message"] ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> deleteCsOutputImage({
    required int oldImageId,
    required int comunicativeSessionId,
  }) async {
    Response response = await dio.delete(
      url: _resCsOuputImage,
      parameters: {
        "image_id": oldImageId,
        "cs_id": comunicativeSessionId,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        "Internal Server Error",
      );
    }
  }

  Future<List<Map<String, dynamic>>> getSocialStories({
    required String option,
    int? userId,
    int? centreId,
    String? text,
    bool? searchMostUsed,
  }) async {
    Response response = await dio.get(url: _resSocialStories, parameters: {
      "option": option,
      "user_id": userId,
      "centre_id": centreId,
      "text": text,
      "search_most_used": searchMostUsed,
    });

    if (response.statusCode == 200) {
      return (response.data["social_story_list"] as List<dynamic>)
          .cast<Map<String, dynamic>>();
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> getSocialStory(int socialStoryId) async {
    Response response = await dio.get(url: _resSocialStory, parameters: {
      "social_story_id": socialStoryId,
    });

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> updateSocialStory(
    Map<String, dynamic> data,
  ) async {
    Response response = await dio.put(
      url: _resSocialStory,
      body: data,
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> createSocialStory(
    Map<String, dynamic> data,
    int userId, {
    int? patientId,
    int? originalSocialStoryId,
  }) async {
    data.putIfAbsent('user_id', () => userId);
    data.putIfAbsent('patient_id', () => patientId);
    data.putIfAbsent('original_social_story_id', () => originalSocialStoryId);

    Response response = await dio.post(
      url: _resSocialStory,
      body: data,
    );

    if (response.statusCode == 201) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> deleteSocialStory(int socialStoryId) async {
    Response response = await dio.delete(
      url: _resSocialStory,
      parameters: {
        "social_story_id": socialStoryId,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        "Internal Server Error",
      );
    }
  }

  //! Non viene usata attualmente
  Future<Map<String, dynamic>> linkSocialStoryToPatient(
    int patientId,
    int socialStoryId,
  ) async {
    final url = "$_resPatient/add-social-story";

    Response response = await dio.post(url: url, parameters: {
      "patient_id": patientId,
      "social_story_id": socialStoryId,
    });

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> insertPatientCsLog(
    Map<String, dynamic> data,
  ) async {
    Response response = await dio.post(url: _resPatientCsLog, body: data);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> addCsOutputImage(int imageId, int csId,
      String searchToken, String translatedPhrase) async {
    Response response = await dio.post(
      url: _resCsOutputPushImage,
      parameters: {
        "image_id": imageId,
        "cs_id": csId,
        "search_token": searchToken,
        "cs_phrase": translatedPhrase,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> sendPasswordResetEmail(String email) async {
    Response response = await dio.post(
      url: _resResetPassword,
      body: {
        "email": email,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> sendAccountDeletionRequest(String userId) async {
    Response response = await dio.post(
      url: "/delete-request",
      body: {
        "user_id": userId,
      },
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        "Internal Server Error",
      );
    }
  }
}
