import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:typed_data';
import '../FTLMVSaveInfo.dart';
import 'ShipImgs.dart';
import 'ShipNames.dart';


class MVSaveInfoParser {
  static const int SHIP_NAME_OFFSET = 0x24;
  final shipNames = ShipNames();
  final shipImages = ShipImgs();

  FTLMVSaveInfo parse(String filename, { String filePath = "" }) {
    var file = _getFile(filename, filePath: filePath);
    var bytes = file.readAsBytesSync();
    var hash = _getHash(bytes);

    int offset, offsetEnd, length;
    offset = SHIP_NAME_OFFSET;
    offsetEnd = _findUnreadableByteIndex(bytes, SHIP_NAME_OFFSET);
    length = offsetEnd - offset;
    var name = _readByteAsString(bytes, offset, length);

    offset = _findReadableByteIndex(bytes, offsetEnd);
    offsetEnd = _findUnreadableByteIndex(bytes, offset);
    length = offsetEnd - offset;

    var shipRaw = _readByteAsString(bytes, offset, length);
    var ship = shipNames[shipRaw] ?? shipRaw;
    var img = "${shipImages[shipRaw]}_base.png";

    return FTLMVSaveInfo(
        name: name,
        ship: ship,
        img: img,
        fileName: filename,
        filePath: filePath,
        dateTime: file.lastModifiedSync(),
        hash : hash,
    );
  }

  File _getFile(String filename, { String filePath = "" }) {
    if (filePath == "") {
      return File(filename);
    }
    else if (filePath.endsWith(r"\") || filePath.endsWith("/")) {
      return File("$filePath$filename");
    }
    else {
      return File("$filePath\\$filename");
    }
  }

  int _findReadableByteIndex(Uint8List bytes, int startOffset) {
    for (int i = startOffset; i < bytes.length; i++) {
      var ch = String.fromCharCode(bytes[i]);

      if (_isPrintable(ch)) {
        return i;
      }
    }
    return -1;
  }
  int _findUnreadableByteIndex(Uint8List bytes, int startOffset) {
    for (int i = startOffset; i < bytes.length; i++) {
      var ch = String.fromCharCode(bytes[i]);

      if (!_isPrintable(ch)) {
        return i;
      }
    }
    return -1;
  }

  String _readByteAsString(Uint8List bytes, int startOffset, int length) {
    var buffer = StringBuffer();
    for(int i = 0; i < length; i++) {
      var byte = bytes[startOffset + i];
      var ch = String.fromCharCode(byte);
      buffer.write(ch);
    }
    return buffer.toString();
  }

  bool _isPrintable(String char) {
    final printable = RegExp(r'^[A-Za-z0-9_. ]+$');
    return printable.hasMatch(char);
  }

  String _getHash(List<int> bytes) {
    var hash = sha256.convert(bytes);
    return "$hash";
  }
}