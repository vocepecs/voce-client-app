import 'dart:async';
import 'package:dio/dio.dart';
import 'package:voce/exceptions/voce_api_exception.dart';
import 'package:voce/services/dio_manager.dart';

class AuthRepository {
  final DioManager dio = DioManager();

  Future<Map<String, dynamic>> signUpUser(Map<String, dynamic> data) async {
    Response response = await dio.post(
      url: "/signup",
      body: data,
    );
    if (response.statusCode == 201) {
      return response.data["user"];
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> handShake() async {
    Response response = await dio.get(url: "/handshake");
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> signInWithEmailAndPassword(
    String username,
    String password,
  ) async {
    Response response = await dio.post(url: "/login", body: {
      "email": username,
      "password": password,
    });

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

  Future<Map<String, dynamic>> signOut() async {
    Response response = await dio.post(url: "/logout");
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw VoceApiException(
        response.statusCode ?? 500,
        response.statusMessage ?? "Internal Server Error",
      );
    }
  }

  Future<Map<String, dynamic>> sendEmailConfirmation(String email) async {
    Response response = await dio.post(
      url: '/send-email-confirmation',
      parameters: {
        "email": email,
      },
    );
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
}
