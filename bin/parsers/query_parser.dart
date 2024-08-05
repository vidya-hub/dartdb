import 'dart:convert';

import '../utils/constants.dart';
import '../utils/file_utils/db_function_utils.dart';

class QueryParser {
  final String query;
  final String userName;

  QueryParser({
    required this.query,
    required this.userName,
  });

  Map<String, dynamic> parse() {
    try {
      // Matching query patterns and delegating to appropriate handlers
      if (RegExp(Constants.CREATE_DB).hasMatch(query)) {
        return _handleCreateDb();
      } else if (RegExp(Constants.GET_DATABASES).hasMatch(query)) {
        return _getDatabases(userName);
      } else if (RegExp(Constants.GET_COLLECTIONS).hasMatch(query)) {
        return _handleGetCollections();
      } else if (RegExp(Constants.CREATE_COLLECTION).hasMatch(query)) {
        return _handleCreateCollection();
      } else if (RegExp(Constants.GET_DATA).hasMatch(query)) {
        return _handleGetData();
      } else if (RegExp(Constants.GET_WITH_FILTER).hasMatch(query)) {
        return _handleGetDataWithFilter();
      } else {
        throw FormatException("Invalid query format.");
      }
    } catch (e) {
      rethrow;
    }
  }

  // Handle the 'create database' command
  Map<String, dynamic> _handleCreateDb() {
    final match = RegExp(Constants.CREATE_DB).firstMatch(query);
    final dbName = match?.group(1);
    if (dbName == null || dbName.isEmpty) {
      throw FormatException("Database name cannot be empty.");
    }
    return _createDatabase(dbName);
  }

  // Handle the 'get collections' command
  Map<String, dynamic> _handleGetCollections() {
    final match = RegExp(Constants.GET_COLLECTIONS).firstMatch(query);
    final dbName = match?.group(1);
    if (dbName == null || dbName.isEmpty) {
      throw FormatException("Database name cannot be empty.");
    }
    return _getCollections(dbName);
  }

  // Handle the 'create collection' command
  Map<String, dynamic> _handleCreateCollection() {
    final match = RegExp(Constants.CREATE_COLLECTION).firstMatch(query);
    final dbName = match?.group(1);
    final collectionName = match?.group(2);
    List<dynamic> params = [];
    Map<dynamic, dynamic> types = {};

    if (dbName == null ||
        dbName.isEmpty ||
        collectionName == null ||
        collectionName.isEmpty) {
      throw FormatException("Database and collection names cannot be empty.");
    }
    print("Here i am");
    if (match?.group(3) != null && match?.group(4) != null) {
      // Extract params and types
      final paramsJson = '[${match?.group(3)}]';
      final typesJson = '{${match?.group(4)}}';
      print({paramsJson, typesJson});
      try {
        params = json.decode(paramsJson);
        types = json.decode(typesJson);
      } catch (e) {
        throw FormatException('Error Parsing Schema: $e');
      }
    }
    return _createCollection(
      dbName,
      collectionName,
      params: params,
      types: types,
    );
  }

  // Handle the 'get data' command
  Map<String, dynamic> _handleGetData() {
    final match = RegExp(Constants.GET_DATA).firstMatch(query);
    final collectionName = match?.group(1);
    if (collectionName == null || collectionName.isEmpty) {
      throw FormatException("Collection name cannot be empty.");
    }
    return _getData(collectionName);
  }

  // Handle the 'get data with filter' command
  Map<String, dynamic> _handleGetDataWithFilter() {
    final match = RegExp(Constants.GET_WITH_FILTER).firstMatch(query);
    final key = match?.group(1);
    final collectionName = match?.group(2);
    final filterKey = match?.group(3);
    final operator = match?.group(4);
    final value = match?.group(5);
    if (key == null ||
        key.isEmpty ||
        collectionName == null ||
        collectionName.isEmpty ||
        filterKey == null ||
        filterKey.isEmpty ||
        operator == null ||
        value == null ||
        value.isEmpty) {
      throw FormatException(
        "Invalid filter query. Ensure all components are provided and valid.",
      );
    }
    return _getDataWithFilter(key, collectionName, filterKey, operator, value);
  }

  // Actual methods to execute commands
  Map<String, dynamic> _createDatabase(String dbName) {
    try {
      DbFunctionUtils.createDb(dbName: dbName, userName: userName);
    } catch (e) {
      rethrow;
    }
    return {};
  }

  Map<String, dynamic> _createCollection(
    String dbName,
    String collectionName, {
    List<dynamic> params = const [],
    Map<dynamic, dynamic> types = const {},
  }) {
    try {
      DbFunctionUtils.createCollection(
        dbName: dbName,
        userName: userName,
        collectionName: collectionName,
        params: params,
        types: types,
      );
    } catch (e) {
      rethrow;
    }
    print('Creating collection: $collectionName in database: $dbName');
    return {};
  }

  Map<String, dynamic> _getCollections(String dbName) {
    try {
      return DbFunctionUtils.getListOfCollections(
        dbName: dbName,
        userName: userName,
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> _getDatabases(String dbName) {
    try {
      return {
        "dbList": DbFunctionUtils.getListOfDatabases(userName: userName),
      };
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> _getData(String collectionName) {
    print('Getting data from collection: $collectionName');
    // Implement the actual data retrieval logic here
    return {};
  }

  Map<String, dynamic> _getDataWithFilter(String key, String collectionName,
      String filterKey, String operator, String value) {
    print(
        'Getting $key from $collectionName where $filterKey $operator $value');
    // Implement the actual data retrieval logic with filtering here
    return {};
  }

  // Add more methods for delete, update, etc. as needed.
}


// // Example usage
// void main() {
//   final parser1 = QueryParser('create db myDatabase');
//   parser1.parse();

//   final parser2 = QueryParser('get * from users');
//   parser2.parse();

//   final parser3 = QueryParser('get name from users where age > 30');
//   parser3.parse();

//   final parser4 = QueryParser('create db '); // Example of an invalid query
//   parser4.parse();
// }
