class UserModel {
  final String id;
  final String username;
  final bool connected;
  final List messages;
  final String type;

  UserModel({
    required this.id,
    required this.username,
    required this.connected,
    required this.messages,
    required this.type,
  });

  factory UserModel.fromMap(Map data) {
    print(data);
    return UserModel(
      id: data['userID'] ?? '',
      username: data['username'] ?? '',
      connected: data['connected'],
      messages: data['messages'],
      type: data['type'],
    );
  }
}
