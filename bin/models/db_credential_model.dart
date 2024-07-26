import 'dart:io';
import '../utils/constants.dart';

class DbCredentialModel {
  String userName;
  String password;
  String dbName;
  DateTime createdAt;
  DateTime updatedAt;
  DbCredentialModel({
    required this.userName,
    required this.password,
    required this.dbName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DbCredentialModel.fromJson(Map<String, dynamic> json) {
    return DbCredentialModel(
      userName: json["userName"] ?? "",
      password: json["dbPassword"] ?? "",
      dbName: json["dbName"] ?? "",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  String get getDbFolder {
    return "${Constants.mainDbDir}/db_files/$dbName";
  }

  String get errorValidation {
    if (userName.isEmpty) {
      return "userName shouldn't be empty";
    }
    if (password.isEmpty) {
      return "password shouldn't be empty";
    }
    if (dbName.isEmpty) {
      return "dbName shouldn't be empty";
    }
    return "";
  }
}
