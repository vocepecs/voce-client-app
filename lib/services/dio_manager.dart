import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioManager {
  late Dio _dio;

  final tokenExpiredError = "token_expired";
  final tokenInvalidError = "invalid_token";
  final unauthorizedError = "unauthorized_request";
  final tokenNotFreshError = "fresh_token_required";
  final tokenRevokedError = "token_revoked";

  final tokenTypeAccess = "access";

  DioManager() {
    _dio = Dio();
    initDio();
  }

  String _server_url = "<insert-your-base-api-url>";

  void initDio() async {
    _dio.options.baseUrl = _server_url;
    _dio.options.connectTimeout = Duration(milliseconds: 5000);
    _dio.options.receiveTimeout = Duration(milliseconds: 20000);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          var prefs = await SharedPreferences.getInstance();
          String? accessToken = prefs.getString('access_token');
          String? refreshToken = prefs.getString('refresh_token');

          if (accessToken == null && refreshToken == null) {
            return handler.next(options);
          } else {
            options.headers['Content-Type'] = 'application/json';
            options.headers['Authorization'] =
                "Bearer ${options.path == '/refresh' ? refreshToken : accessToken}";

            return handler.next(options);
          }
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            if (e.response?.data['error'] == tokenExpiredError) {
              if (e.response?.data['type'] == tokenTypeAccess) {
                String? refreshToken = await _refreshToken();
                if (refreshToken == null) {
                  return handler.next(e);
                } else {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('access_token', refreshToken);
                  e.requestOptions.headers['Authorization'] =
                      'Bearer ' + refreshToken;
                  try {
                    return handler.resolve(await _dio.fetch(e.requestOptions));
                  } catch (error) {
                    return handler.next(e);
                  }
                }
              } else {
                return handler.next(e);
              }
            } else {
              return handler.next(e);
            }
          } else {
            // handle other errors
            return handler.next(e);
          }
        },
      ),
    );
  }

  Future<String?> _refreshToken() async {
    Response response = await _dio.post("/refresh");
    if (response.statusCode == 200) {
      String newToken = response.data['access_token'];
      return newToken;
    } else {
      return null;
    }
  }

  Future<Response> get({
    required String url,
    Map<String, dynamic>? parameters,
    Map<String, dynamic>? body,
  }) async {
    try {
      Response response = await _dio.get(
        url,
        queryParameters: parameters,
        data: body,
      );
      return response;
    } on DioException catch (e) {
      print("Dio Exception on GET ${e.response!.statusCode}");
      return e.response!;
    }
  }

  Future<Response> post({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      Response response = await _dio.post(
        url,
        queryParameters: parameters,
        data: body,
      );
      return response;
    } on DioException catch (e) {
      print("Dio Exception on POST ${e.response!.statusCode}");
      return e.response!;
    }
  }

  Future<Response> put({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      Response response = await _dio.put(
        url,
        queryParameters: parameters,
        data: body,
      );
      return response;
    } on DioException catch (e) {
      print("Dio Exception on PUT ${e.response?.statusCode}");
      return e.response!;
    }
  }

  Future<Response> delete({
    required String url,
    Map<String, dynamic>? body,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      Response response = await _dio.delete(
        url,
        queryParameters: parameters,
        data: body,
      );
      return response;
    } on DioException catch (e) {
      print("Dio Exception on DELETE ${e.response!.statusCode}");
      return e.response!;
    }
  }
}
