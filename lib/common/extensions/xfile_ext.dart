import 'dart:io' as io show File;

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

extension XFileExtensions on XFile {
  MediaType get mediaType {
    return MediaType.parse(lookupMimeType(path) ??
        (throw StateError('The mediaType is unknown for this file: $path')));
  }

  ImageProvider toImageProvider() {
    if (kIsWeb) {
      return NetworkImage(path);
    }
    return FileImage(io.File(path));
  }
}
