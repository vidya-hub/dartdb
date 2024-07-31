import 'dart:convert';

import '../utils/constants.dart';
import '../utils/file_utils/file_utils.dart';

class UserCredentialModel {
  String userName;
  String password;
  DateTime createdAt;
  String dbQuery;
  bool isDataExists;
  bool isValidCredentials;
  UserCredentialModel({
    required this.userName,
    required this.password,
    required this.createdAt,
    this.dbQuery = "",
    required this.isDataExists,
    required this.isValidCredentials,
  });

  factory UserCredentialModel.fromJson(String body) {
    Map<String, dynamic> decodedBody = json.decode(body);
    Map<String, dynamic>? mainDbJson;
    String userName = decodedBody["userName"] ?? "";
    String password = decodedBody["password"] ?? "";
    if (userName.isNotEmpty) {
      String mainDbJsonFile = Constants.mainDbJsonFile;
      mainDbJson = (readFile(mainDbJsonFile) ?? {});
    }

    return UserCredentialModel(
      userName: userName,
      password: password,
      createdAt: DateTime.now(),
      dbQuery: decodedBody["query"] ?? "",
      isDataExists: mainDbJson?[userName] != null,
      isValidCredentials: _isValidCredentials(
        mainDbJson,
        userName,
        password,
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "password": password,
      "createdAt": createdAt.toIso8601String()
    };
  }

  static bool _isValidCredentials(
    Map? credentialsJson,
    String userName,
    String password,
  ) {
    return credentialsJson != null &&
        credentialsJson[userName] != null &&
        credentialsJson[userName]["password"] == password;
  }

  String get errorValidation {
    if (userName.isEmpty) {
      return "userName shouldn't be empty";
    }
    if (password.isEmpty) {
      return "password shouldn't be empty";
    }

    return "";
  }
}
