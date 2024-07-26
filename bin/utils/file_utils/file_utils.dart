import 'dart:convert';
import 'dart:io';

void createFile(String filename) {
  try {
    Directory currentDirectory = Directory.current;
    File("${currentDirectory.path}/$filename").createSync();
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
