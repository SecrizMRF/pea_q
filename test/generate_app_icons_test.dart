import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pea_q/app/theme/app_colors.dart';
import 'package:pea_q/widgets/peaqook_logo.dart';

void main() {
  test('Generate PeaQook Peacock App Icons for Android and Assets synchronously', () async {
    final sizes = {
      'assets/images/logo.png': 512,
      'android/app/src/main/res/mipmap-mdpi/ic_launcher.png': 48,
      'android/app/src/main/res/mipmap-hdpi/ic_launcher.png': 72,
      'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png': 96,
      'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png': 144,
      'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png': 192,
    };

    for (final entry in sizes.entries) {
      final filePath = entry.key;
      final dimension = entry.value;

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(
        recorder,
        Rect.fromLTWH(0, 0, dimension.toDouble(), dimension.toDouble()),
      );

      final painter = PeaQookLogoPainter(
        primaryColor: AppColors.lightPrimary,
        secondaryColor: AppColors.lightSecondary,
        accentColor: AppColors.lightAccent,
      );

      painter.paint(
        canvas,
        Size(dimension.toDouble(), dimension.toDouble()),
      );

      final picture = recorder.endRecording();
      final img = picture.toImageSync(dimension, dimension);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        final buffer = byteData.buffer.asUint8List();
        final file = File(filePath);
        await file.parent.create(recursive: true);
        await file.writeAsBytes(buffer);
      }
    }
  });
}
