class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final bool requiresEmailConfirmation;

  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.requiresEmailConfirmation = false,
  });

  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    bool? requiresEmailConfirmation,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      requiresEmailConfirmation:
          requiresEmailConfirmation ?? this.requiresEmailConfirmation,
    );
  }
}
