class UserModel {
  int? id;
  String? name;
  String? email;
  String? username;
  String? profilePhotoUrl;
  String? token;
  String? permanentToken;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.profilePhotoUrl,
    this.token,
    this.permanentToken,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    username = json['username'];
    profilePhotoUrl = json['profile_photo_url'];
    token = json['token'];
    permanentToken = json['permanent_token'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'profile_photo_url': profilePhotoUrl,
      'token': token,
      'permanent_token': permanentToken,
    };
  }
}
