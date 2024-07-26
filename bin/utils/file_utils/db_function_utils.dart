import '../file_utils/file_utils.dart';
import '../../models/db_credential_model.dart';
import '../constants.dart';

class DbFunctionUtils {
  static void createDbData({
    required DbCredentialModel dbCredentialModel,
  }) {
    String dbFolderName = dbCredentialModel.getDbFolder;
    String dbFileName = dbCredentialModel.dbFileName;
    String mainDbJsonFile = Constants.mainDbJsonFile;
    Map<String, dynamic>? mainDbJson = (readFile(mainDbJsonFile) ?? {});
    mainDbJson[dbCredentialModel.dbName] = dbCredentialModel.toJson();
    writeFile(
      filename: mainDbJsonFile,
      data: mainDbJson,
    );
    createDirectory(dbFolderName);
    createFile(dbFileName);
    writeFile(
      filename: dbFileName,
      data: {
        "dbCredential": dbCredentialModel.toJson(),
      },
    );
  }
}
