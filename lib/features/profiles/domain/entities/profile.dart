class Profile {
  final String id;
  final String? displayName;
  final DateTime createdAt;

  const Profile({required this.id, this.displayName, required this.createdAt});

  Profile copyWith({String? id, String? displayName, DateTime? createdAt}) {
    return Profile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
