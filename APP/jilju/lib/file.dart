import 'package:flutter/services.dart';

class FileManager {
  static Future<String> readFileAsString(String fileName) {
    return rootBundle.loadString('assets/' + fileName);
  }
}
