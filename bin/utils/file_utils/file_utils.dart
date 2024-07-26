import 'dart:convert';
import 'dart:io';

void createDirectory(String directoryName) {
  Directory directory = Directory(directoryName);
  directory.createSync(recursive: true);
}

void createFile(String filename) {
  File file = File(filename);
  if (file.existsSync()) {
    return;
  }
  try {
    file.createSync(recursive: false);
  } catch (e) {
    throw Exception("File create error $e");
  }
}

Map<String, dynamic>? readFile(String filename) {
  try {
    Directory currentDirectory = Directory.current;
    String fileContent =
        File("${currentDirectory.path}/$filename").readAsStringSync();
    if (fileContent.isEmpty) {
      return {};
    }
    return jsonDecode(fileContent);
  } catch (e) {
    throw Exception("File Read error $e");
  }
}

void writeFile({
  required String filename,
  required Map<String, dynamic> data,
}) {
  try {
    Directory currentDirectory = Directory.current;
    File("${currentDirectory.path}/$filename").writeAsStringSync(
      jsonEncode(data),
    );
  } catch (e) {
    throw Exception("File Write error $e");
  }
}
