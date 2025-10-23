class UserModel {
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.photoUrl,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['id'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'email': email,
    };
  }
}