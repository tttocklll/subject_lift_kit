import 'package:flutter_test/flutter_test.dart';
import 'package:subject_lift_kit/subject_lift_kit.dart';
import 'package:subject_lift_kit/subject_lift_kit_platform_interface.dart';
import 'package:subject_lift_kit/subject_lift_kit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSubjectLiftKitPlatform
    with MockPlatformInterfaceMixin
    implements SubjectLiftKitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SubjectLiftKitPlatform initialPlatform = SubjectLiftKitPlatform.instance;

  test('$MethodChannelSubjectLiftKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSubjectLiftKit>());
  });

  test('getPlatformVersion', () async {
    SubjectLiftKit subjectLiftKitPlugin = SubjectLiftKit();
    MockSubjectLiftKitPlatform fakePlatform = MockSubjectLiftKitPlatform();
    SubjectLiftKitPlatform.instance = fakePlatform;

    expect(await subjectLiftKitPlugin.getPlatformVersion(), '42');
  });
}
