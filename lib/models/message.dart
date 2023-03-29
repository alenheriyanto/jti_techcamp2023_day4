class Message {
  final String id, profileId, content;
  final DateTime createdAt;
  final bool isMine;

  Message(
      {required this.id,
      required this.profileId,
      required this.content,
      required this.createdAt,
      required this.isMine});

  factory Message.fromMap(
          {required Map<String, dynamic> map, required String myUserId}) =>
      Message(
          id: map['id'],
          profileId: map['profile_id'],
          content: map['content'],
          createdAt: DateTime.parse(map['created_at']),
          isMine: myUserId == map['profile_id']);
}
