import 'package:spend_wise/core/services/app_clock.dart';

abstract class IdGenerator {
  String generate();
}

/// Simple timestamp-based ID generator. Replaceable for Firebase/UUID later.
class TimestampIdGenerator implements IdGenerator {
  final AppClock _clock;

  const TimestampIdGenerator(this._clock);

  @override
  String generate() => _clock.now().microsecondsSinceEpoch.toString();
}
