class UserModel {
  final String id;
  final String username;

  UserModel({
    required this.id,
    required this.username,
  });

  factory UserModel.fromMap(Map data) {
    return UserModel(
      id: data['userID'] ?? '',
      username: data['username'] ?? '',
    );
  }
}
