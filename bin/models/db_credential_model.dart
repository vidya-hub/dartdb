import '../utils/constants.dart';
import 'package:path/path.dart' as path;

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
  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "dbPassword": password,
      "dbName": dbName,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "dbFolder": getDbFolder,
      "dbFileName": dbFileName,
    };
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

  String get getDbFolder {
    return path.join(Constants.mainDbDir, dbName);
  }

  String get dbFileName {
    return path.join(getDbFolder, "$dbName.json");
  }
}
