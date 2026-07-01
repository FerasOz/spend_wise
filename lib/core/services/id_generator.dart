import 'dart:math';

import 'package:spend_wise/core/services/app_clock.dart';

abstract class IdGenerator {
  String generate();
}

/// UUID v4 generator for backend-safe primary keys.
class TimestampIdGenerator implements IdGenerator {
  final AppClock _clock;

  const TimestampIdGenerator(this._clock);

  @override
  String generate() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    String two(int value) => value.toRadixString(16).padLeft(2, '0');
    final hex = bytes.map(two).join();
    return '${hex.substring(0, 8)}-'
        '${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-'
        '${hex.substring(16, 20)}-'
        '${hex.substring(20)}';
  }
}
