import 'dart:convert';
import 'dart:io';

import 'package:pretty_print_json/pretty_print_json.dart';
import 'package:path/path.dart' as path;

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
    String dirPath = path.join(".", currentDirectory.path, filename);
    print(dirPath);

    String fileContent = File(dirPath).readAsStringSync();
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
    String dirPath = path.join(".", currentDirectory.path, filename);
    print(dirPath);
    File(dirPath).writeAsStringSync(
      prettyJson(jsonEncode(data)),
    );
  } catch (e) {
    throw Exception("File Write error $e");
  }
}
