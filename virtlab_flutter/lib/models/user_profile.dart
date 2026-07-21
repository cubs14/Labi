class UserProfile {
  final String uid;
  final String fullName;
  final String username;
  final String email;
  final String birthDate; // yyyy-MM-dd
  final String country;
  final String department;
  final String municipality;
  final String photoUrl;
  final int level;
  final int xp;

  const UserProfile({
    required this.uid,
    required this.fullName,
    required this.username,
    required this.email,
    required this.birthDate,
    required this.country,
    required this.department,
    required this.municipality,
    required this.photoUrl,
    this.level = 1,
    this.xp = 0,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> map) {
    return UserProfile(
      uid: uid,
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      birthDate: map['birthDate'] ?? '',
      country: map['country'] ?? '',
      department: map['department'] ?? '',
      municipality: map['municipality'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      level: map['level'] ?? 1,
      xp: map['xp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'username': username,
        'email': email,
        'birthDate': birthDate,
        'country': country,
        'department': department,
        'municipality': municipality,
        'photoUrl': photoUrl,
        'level': level,
        'xp': xp,
      };

  UserProfile copyWith({String? photoUrl, int? level, int? xp}) => UserProfile(
        uid: uid,
        fullName: fullName,
        username: username,
        email: email,
        birthDate: birthDate,
        country: country,
        department: department,
        municipality: municipality,
        photoUrl: photoUrl ?? this.photoUrl,
        level: level ?? this.level,
        xp: xp ?? this.xp,
      );
}
