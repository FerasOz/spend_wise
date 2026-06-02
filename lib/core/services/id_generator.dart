abstract class IdGenerator {
  String generate();
}

/// Simple timestamp-based ID generator. Replaceable for Firebase/UUID later.
class TimestampIdGenerator implements IdGenerator {
  const TimestampIdGenerator();

  @override
  String generate() => DateTime.now().microsecondsSinceEpoch.toString();
}
