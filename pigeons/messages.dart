import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartPackageName: "subject_lift_kit",
    dartOut: 'lib/gen/messages.g.dart',
    dartOptions: DartOptions(),
    swiftOut: 'ios/Classes/Messages.g.swift',
    swiftOptions: SwiftOptions(),
  ),
)
/// Input image data for segmentation
class ImageData {
  ImageData({required this.imageBytes});

  final Uint8List imageBytes;
}

/// Result of the segmentation operation
class SegmentationResult {
  SegmentationResult({this.maskImageBytes, this.cutoutImageBytes, this.error});

  /// Binary mask image data
  final Uint8List? maskImageBytes;

  /// Cutout image with transparent background
  final Uint8List? cutoutImageBytes;

  /// Error message if the operation failed
  final String? error;
}

/// Host API for subject lifting operations
@HostApi()
abstract class SubjectLiftApi {
  /// Extract foreground objects from the given image
  @async
  SegmentationResult extractForeground(ImageData imageData);
}
