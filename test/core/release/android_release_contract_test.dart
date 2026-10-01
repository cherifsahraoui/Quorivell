import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory repoRoot;

  setUpAll(() {
    repoRoot = _findRepoRoot();
  });

  test('pubspec version is name or name+build and notes use versionName', () {
    final pubspec = File('${repoRoot.path}/pubspec.yaml').readAsStringSync();
    final version = RegExp(
      r'^version:\s*(.+)$',
      multiLine: true,
    ).firstMatch(pubspec)?.group(1)?.trim();
    expect(version, isNotNull);
    expect(version, matches(RegExp(r'^\d+\.\d+\.\d+(\+\d+)?$')));

    final versionName = version!.split('+').first;
    final notesFile = File(
      '${repoRoot.path}/docs/google-play/release-notes.md',
    );
    // Public clone omits docs/google-play/ (.publicignore); private CI still checks.
    if (!notesFile.existsSync()) {
      markTestSkipped('docs/google-play/release-notes.md is private-only');
      return;
    }
    expect(notesFile.readAsStringSync(), contains('`$versionName`'));
  });

  test('AndroidManifest disables Auto Backup of local records', () {
    final manifest = File(
      '${repoRoot.path}/android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    expect(manifest, contains('android:allowBackup="false"'));
    expect(
      manifest,
      contains('android:dataExtractionRules="@xml/data_extraction_rules"'),
    );

    final rules = File(
      '${repoRoot.path}/android/app/src/main/res/xml/data_extraction_rules.xml',
    ).readAsStringSync();
    expect(rules, contains('<cloud-backup>'));
    expect(rules, contains('<device-transfer>'));
    expect(rules, contains('<exclude domain="database" path="." />'));
  });
}

Directory _findRepoRoot() {
  var dir = Directory.current;
  for (var i = 0; i < 8; i++) {
    if (File('${dir.path}${Platform.pathSeparator}pubspec.yaml').existsSync()) {
      return dir;
    }
    dir = dir.parent;
  }
  throw StateError(
    'Could not find pubspec.yaml from ${Directory.current.path}',
  );
}
