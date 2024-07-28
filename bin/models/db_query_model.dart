import 'dart:convert';
import '../utils/constants.dart';
import '../utils/file_utils/file_utils.dart';

import '../parsers/query_parser.dart';

class DbQueryModel {
  String userName;
  String password;
  String dbQuery;
  Map? userCredentials;
  bool validCredentials;
  QueryParser queryParser;
  DbQueryModel({
    required this.userName,
    required this.password,
    required this.dbQuery,
    this.userCredentials,
    this.validCredentials = false,
    required this.queryParser,
  });
  factory DbQueryModel.fromJson(String queryBody) {
    Map<String, dynamic> decodedBody = json.decode(queryBody);
    print(decodedBody);
    String userName = decodedBody["userName"] ?? "";
    String password = decodedBody["password"] ?? "";
    String dbQuery = decodedBody["query"] ?? "";
    Map<String, dynamic>? mainDbJson;
    if (userName.isNotEmpty) {
      String mainDbJsonFile = Constants.mainDbJsonFile;
      mainDbJson = (readFile(mainDbJsonFile) ?? {});
    }
    return DbQueryModel(
      userName: userName,
      password: password,
      dbQuery: dbQuery,
      userCredentials: mainDbJson,
      validCredentials: _isValidCredentials(
        mainDbJson,
        userName,
        password,
      ),
      queryParser: QueryParser(
        query: dbQuery,
        userName: userName,
      ),
    );
  }
  Map<String, dynamic> executeQuery() {
    return queryParser.parse();
  }

  String get errorValidation {
    if (userName.isEmpty) {
      return "userName shouldn't be empty";
    }
    if (password.isEmpty) {
      return "password shouldn't be empty";
    }
    if (!validCredentials) {
      return "Invalid credentials";
    }

    return "";
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
}
