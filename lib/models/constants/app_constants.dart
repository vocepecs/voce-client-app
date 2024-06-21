import 'package:voce/models/enums/auth_error_type.dart';

const String APP_VERSION = "2.2.1";

const Map<AuthErrorType,String> MAP_ERROR_MESSAGE = {
  AuthErrorType.USER_ALREADY_EXISTS: "Utente già registrato",
  AuthErrorType.USER_NOT_FOUND: "Utente non trovato",
  AuthErrorType.WRONG_PASSWORD_CONFIRMATION: "Conferma password errata",
  AuthErrorType.EMPTY_FIELD_DATA: "Compila tutti i campi",
  AuthErrorType.INVALID_EMAIL: "Email non valida",
  AuthErrorType.INVALID_CREDENTIALS: "Credenziali non valide",
  AuthErrorType.GENERIC_ERROR: "C'e' stato un errore, riprova piu' tardi",
};
