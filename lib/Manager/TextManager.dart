import 'dart:io';
import 'package:csv/csv.dart';
import '../dev.dart';

class TextManager {
  final dict = <String, String>{};
  String targetFile;

  TextManager({
    required this.targetFile,
  });

  loadFile() async {
    devPrint("loadFile : $targetFile");

    var file = File(targetFile);
    if (file.existsSync()) {
      String fileContent = file.readAsStringSync();
      List<List<dynamic>> csvData = const CsvToListConverter().convert(fileContent);

      for (var row in csvData) {
        this[row[0]] = row[1];
      }
    } else {
      devPrint("[Warning] load fail : '$targetFile'");
    }
  }

  String operator [](String key) {
    return dict[key.toUpperCase()] ?? key;
  }

  void operator []=(String key, String value) {
    dict[key.toUpperCase()] = value;
  }
}