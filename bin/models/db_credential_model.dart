import 'dart:convert';

import '../utils/constants.dart';
import '../utils/file_utils/file_utils.dart';

class UserCredentialModel {
  String userName;
  String password;
  DateTime createdAt;
  String dbQuery;
  bool isDataExists;
  UserCredentialModel({
    required this.userName,
    required this.password,
    required this.createdAt,
    this.dbQuery = "",
    required this.isDataExists,
  });

  factory UserCredentialModel.fromJson(String body) {
    Map<String, dynamic> decodedBody = json.decode(body);
    Map<String, dynamic>? mainDbJson;
    String userName = decodedBody["userName"] ?? "";
    if (userName.isNotEmpty) {
      String mainDbJsonFile = Constants.mainDbJsonFile;
      mainDbJson = (readFile(mainDbJsonFile) ?? {});
    }

    return UserCredentialModel(
      userName: userName,
      password: decodedBody["password"] ?? "",
      createdAt: DateTime.now(),
      dbQuery: decodedBody["query"] ?? "",
      isDataExists: mainDbJson?[userName] != null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "password": password,
      "createdAt": createdAt.toIso8601String()
    };
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
