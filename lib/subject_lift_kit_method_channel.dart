import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'subject_lift_kit_platform_interface.dart';

/// An implementation of [SubjectLiftKitPlatform] that uses method channels.
class MethodChannelSubjectLiftKit extends SubjectLiftKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('subject_lift_kit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
