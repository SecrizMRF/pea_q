import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Verify PeaQook PNG Logo Asset Exists', () async {
    final logoFile = File('assets/images/logo.png');
    expect(logoFile.existsSync(), true, reason: 'assets/images/logo.png harus ada');
    expect(logoFile.lengthSync() > 0, true, reason: 'assets/images/logo.png tidak boleh kosong');
  });
}
