# Subject Lift Kit

A Flutter plugin for extracting foreground objects from images using iOS Vision Framework's `VNGenerateForegroundInstanceMaskRequest`.

## Features

- 🎯 Extract foreground objects from images (people, animals, objects)
- 🖼️ Generate transparent background cutouts
- 📱 iOS 17.0+ support using Apple's Vision Framework

## Requirements

- iOS 17.0 or later
- Physical iOS device (simulator not supported)
- Flutter 3.3.0+

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  subject_lift_kit: ^0.0.1
```

## Usage

### Basic Usage

```dart
import 'package:subject_lift_kit/subject_lift_kit.dart';
import 'dart:typed_data';

// Load your image as Uint8List
Uint8List imageBytes = await loadImageBytes();

try {
  // Extract foreground objects
  final result = await SubjectLiftKit.extractForeground(imageBytes);
  
  // Use the results
  if (result.cutoutImageBytes != null) {
    // Display the cutout image with transparent background
    Image.memory(result.cutoutImageBytes!);
  }
  
  if (result.maskImageBytes != null) {
    // Display the binary mask
    Image.memory(result.maskImageBytes!);
  }
} catch (e) {
  print('Error: $e');
}
```

### Check Device Compatibility

```dart
bool isSupported = await SubjectLiftKit.isSupported();
if (!isSupported) {
  print('Device does not support subject lifting');
}
```

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:subject_lift_kit/subject_lift_kit.dart';

class SubjectLiftExample extends StatefulWidget {
  @override
  _SubjectLiftExampleState createState() => _SubjectLiftExampleState();
}

class _SubjectLiftExampleState extends State<SubjectLiftExample> {
  SegmentationResult? _result;
  bool _isProcessing = false;

  Future<void> _pickAndProcessImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final bytes = await image.readAsBytes();
      final result = await SubjectLiftKit.extractForeground(bytes);
      
      setState(() {
        _result = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subject Lift Kit')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _isProcessing ? null : _pickAndProcessImage,
            child: _isProcessing
                ? CircularProgressIndicator()
                : Text('Pick & Process Image'),
          ),
          if (_result?.cutoutImageBytes != null)
            Expanded(
              child: Image.memory(_result!.cutoutImageBytes!),
            ),
        ],
      ),
    );
  }
}
```

## API Reference

### `SubjectLiftKit`

#### Methods

- `static Future<SegmentationResult> extractForeground(Uint8List imageBytes)`
  - Extracts foreground objects from the given image
  - Returns a `SegmentationResult` with mask and cutout images
  - Throws `SubjectLiftException` on error

- `static Future<bool> isSupported()`
  - Checks if the current device supports subject lifting
  - Returns `true` for iOS 17.0+ devices

### `SegmentationResult`

- `Uint8List? maskImageBytes` - Binary mask image as PNG data
- `Uint8List? cutoutImageBytes` - Cutout image with transparent background as PNG data
- `String? error` - Error message if operation failed

### `SubjectLiftException`

Exception thrown when subject lifting operations fail.

## Limitations

- **iOS Only**: Currently only supports iOS platform
- **iOS 17.0+**: Requires iOS 17.0 or later
- **Physical Device**: Does not work on iOS Simulator

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.

## Credits

Built using Apple's Vision Framework and the VNGenerateForegroundInstanceMaskRequest API.