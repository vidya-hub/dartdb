import 'dart:io';

import '../file_utils/file_utils.dart';
import '../../models/db_credential_model.dart';
import '../constants.dart';
import "package:path/path.dart" as path;
import '../../models/exception/database_exec_exception.dart';

class DbFunctionUtils {
  static void saveUserCredentials({
    required UserCredentialModel userCredentials,
  }) {
    String mainDbJsonFile = Constants.mainDbJsonFile;
    Map<String, dynamic>? mainDbJson = (readFile(mainDbJsonFile) ?? {});
    mainDbJson[userCredentials.userName] = userCredentials.toJson();
    writeFile(
      filename: mainDbJsonFile,
      data: mainDbJson,
    );
  }

  static void createDb({
    required String dbName,
    required String userName,
  }) {
    String dbPath = path.join(
      Constants.dbFilesDire,
      userName,
      "${dbName}_db",
    );
    String dbCollectionsPath = path.join(
      dbPath,
      "${dbName}_collections",
    );
    String dbCollectionsListPath = path.join(
      dbPath,
      "${dbName}_collections.json",
    );
    if (Directory(dbPath).existsSync()) {
      throw DatabaseExecException(
        "Database already exists.",
      );
    }
    String dbMainCollectionsPath = path.join(
      dbCollectionsPath,
      "main.json",
    );

    createDirectory(dbPath);
    createDirectory(dbCollectionsPath);
    createFile(dbCollectionsListPath);
    String dt = DateTime.now().toIso8601String();
    writeFile(
      filename: dbCollectionsListPath,
      data: {
        "createdAt": dt,
        "updatedAt": dt,
        "collectionList": [
          "main",
        ]
      },
    );
    writeFile(
      filename: dbMainCollectionsPath,
      data: {
        "createdAt": dt,
        "updatedAt": dt,
      },
    );
  }

  static void createCollection({
    required String dbName,
    required String userName,
    required String collectionName,
  }) {
    String dbPath = path.join(
      Constants.dbFilesDire,
      userName,
      "${dbName}_db",
    );

    String dbCollectionsListPath = path.join(
      dbPath,
      "${dbName}_collections.json",
    );
    String currentCollectionPath = path.join(
      dbPath,
      "${dbName}_collections",
      "$collectionName.json",
    );

    createFile(dbCollectionsListPath);
    String dt = DateTime.now().toIso8601String();
    Map<String, dynamic>? collectionsListData = readFile(dbCollectionsListPath);
    List currentCollectionList = collectionsListData?["collectionList"];
    if (currentCollectionList.contains(collectionName)) {
      throw DatabaseExecException(
        "Collection already exists.",
      );
    }

    currentCollectionList.add(collectionName);
    collectionsListData?["collectionList"] = currentCollectionList;
    collectionsListData?["updatedAt"] = dt;
    writeFile(
      filename: dbCollectionsListPath,
      data: collectionsListData ?? {},
    );
    writeFile(
      filename: currentCollectionPath,
      data: {
        "createdAt": dt,
        "updatedAt": dt,
        "data": [],
      },
    );
  }

  static Map<String, dynamic> getListOfCollections({
    required String dbName,
    required String userName,
  }) {
    String dbPath = path.join(
      Constants.dbFilesDire,
      userName,
      "${dbName}_db",
    );
    if (!Directory(dbPath).existsSync()) {
      throw DatabaseExecException("Database does not exist.");
    }

    String dbCollectionsListPath = path.join(
      dbPath,
      "${dbName}_collections.json",
    );
    Map<String, dynamic>? collectionsListData = readFile(
      dbCollectionsListPath,
    );
    List currentCollectionList = collectionsListData?["collectionList"];
    return {
      "collectionList": currentCollectionList,
    };
  }

  static Map<String, dynamic> getData({
    required String collectionName,
    required String dbName,
    required String userName,
    required String filter,
  }) {
    String currentCollectionPath = path.join(
      Constants.dbFilesDire,
      userName,
      "${dbName}_db",
      "${dbName}_collections",
      "$collectionName.json",
    );
    Map<String, dynamic>? collectionData = readFile(currentCollectionPath);
    return {};
  }
}
