class AppUser {
  final String id;
  final String email;
  final String? displayName;
  final bool requiresEmailConfirmation;

  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.requiresEmailConfirmation = false,
  });

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    bool? requiresEmailConfirmation,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      requiresEmailConfirmation:
          requiresEmailConfirmation ?? this.requiresEmailConfirmation,
    );
  }
}
