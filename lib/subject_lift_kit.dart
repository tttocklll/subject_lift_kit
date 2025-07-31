import 'dart:typed_data';

import 'package:subject_lift_kit/src/messages.g.dart';

export 'src/messages.g.dart' show SegmentationResult;

/// The main plugin class for subject lifting operations
class SubjectLiftKit {
  static final _api = SubjectLiftApi();

  /// Extract foreground objects from the given image
  /// 
  /// Returns a [SegmentationResult] containing:
  /// - [maskImageBytes]: The binary mask as PNG data
  /// - [cutoutImageBytes]: The cutout image with transparent background as PNG data
  /// - [error]: An error message if the operation failed
  /// 
  /// Throws [SubjectLiftException] if the operation fails
  static Future<SegmentationResult> extractForeground(Uint8List imageBytes) async {
    final imageData = ImageData(imageBytes: imageBytes);
    final result = await _api.extractForeground(imageData);
    
    if (result.error != null) {
      throw SubjectLiftException(result.error!);
    }
    
    return result;
  }

  /// Check if the current device supports subject lifting
  /// 
  /// Returns true if the device runs iOS 17.0 or later
  static Future<bool> isSupported() async {
    try {
      // Try with a small test image
      final testImage = Uint8List.fromList([0]);
      final result = await _api.extractForeground(ImageData(imageBytes: testImage));
      
      // Check if the error is about iOS version
      if (result.error?.contains('iOS 17.0') ?? false) {
        return false;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Exception thrown when subject lifting operations fail
class SubjectLiftException implements Exception {
  final String message;
  
  SubjectLiftException(this.message);
  
  @override
  String toString() => 'SubjectLiftException: $message';
}