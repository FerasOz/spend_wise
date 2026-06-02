abstract class AppClock {
  DateTime now();
}

class SystemAppClock implements AppClock {
  const SystemAppClock();

  @override
  DateTime now() => DateTime.now();
}
