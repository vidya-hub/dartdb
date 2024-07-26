import 'package:path/path.dart' as path;

class Constants {
  static String get mainDbDir {
    return path.join(dbFilesDire, "main");
  }

  static String get dbFilesDire {
    return path.join("db_files");
  }

  static String get mainDbJsonFile {
    return path.join(
      mainDbDir,
      "db_list.json",
    );
  }
}
