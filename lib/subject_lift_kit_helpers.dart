import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';

/// Helper methods for working with subject lifting results
class SubjectLiftHelpers {
  /// Convert a File to Uint8List
  static Future<Uint8List> fileToBytes(File file) async {
    return await file.readAsBytes();
  }
  
  /// Create an Image widget from bytes
  static Image imageFromBytes(Uint8List bytes) {
    return Image.memory(bytes);
  }
  
  /// Save bytes to a file
  static Future<File> saveToFile(Uint8List bytes, String path) async {
    final file = File(path);
    await file.writeAsBytes(bytes);
    return file;
  }
  
  /// Convert image provider to bytes (for loading from assets, network, etc.)
  static Future<Uint8List?> imageProviderToBytes(ImageProvider provider) async {
    try {
      final stream = provider.resolve(const ImageConfiguration());
      final completer = Completer<ImageInfo>();
      
      void listener(ImageInfo info, bool _) {
        completer.complete(info);
      }
      
      stream.addListener(ImageStreamListener(listener));
      final imageInfo = await completer.future;
      stream.removeListener(ImageStreamListener(listener));
      
      final byteData = await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }
}