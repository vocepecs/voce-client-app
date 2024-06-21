class VoceApiException implements Exception {
  int statusCode;
  String message;
  Map<String, dynamic>? data;
  VoceApiException(this.statusCode, this.message, {this.data});
}
