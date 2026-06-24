class AppUser {
  final String id;
  final String email;
  final String? displayName;

  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
  });

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }
}