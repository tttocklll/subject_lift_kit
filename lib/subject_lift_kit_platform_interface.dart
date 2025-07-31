import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'subject_lift_kit_method_channel.dart';

abstract class SubjectLiftKitPlatform extends PlatformInterface {
  /// Constructs a SubjectLiftKitPlatform.
  SubjectLiftKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static SubjectLiftKitPlatform _instance = MethodChannelSubjectLiftKit();

  /// The default instance of [SubjectLiftKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelSubjectLiftKit].
  static SubjectLiftKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SubjectLiftKitPlatform] when
  /// they register themselves.
  static set instance(SubjectLiftKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
