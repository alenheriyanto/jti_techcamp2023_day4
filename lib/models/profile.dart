class Profile {
  final String id, username;
  final DateTime createdAt;

  Profile({required this.id, required this.username, required this.createdAt});

  factory Profile.fromMap(Map<String, dynamic> map) => Profile(
      id: map['id'],
      username: map['username'],
      createdAt: DateTime.parse(map['created_at']));
}
