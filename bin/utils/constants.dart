import 'package:path/path.dart' as path;

class Constants {
  // Examples of query patterns
  static String CREATE_DB = r'create db (\w+)';
  static String GET_DATABASES = r'get databases';
  static String GET_COLLECTIONS = r'get collections from (\w+)';
  static String CREATE_COLLECTION = r'create collection (\w+)\.(\w+)';
  static String GET_DATA = r'get \* from (\w+)';
  static String GET_WITH_FILTER =
      r'get (\w+) from (\w+) where (\w+) (==|>|<|!=) (\w+)';
// Add other patterns for delete, update, etc.

  static String get mainDbDir {
    return path.join(dbFilesDire, "main");
  }

  static String dbFilesDire = "db_files";

  static String get mainDbJsonFile {
    return path.join(
      mainDbDir,
      "users.json",
    );
  }
}
