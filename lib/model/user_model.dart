// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.users,
  });

  List<UserElement>? users;

  factory User.fromJson(Map<String, dynamic> json) => User(
        users: json["users"] == null
            ? null
            : List<UserElement>.from(
                json["users"].map((x) => UserElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "users": users == null
            ? null
            : List<dynamic>.from(users!.map((x) => x.toJson())),
      };
}

class UserElement {
  UserElement(
      {this.createdAt,
      this.email,
      this.firstName,
      this.id,
      this.lastName,
      this.updatedAt,
      this.bio,
      this.isFavourite});

  DateTime? createdAt;
  String? email;
  String? firstName;
  String? id;
  String? lastName;
  DateTime? updatedAt;
  String? bio;
  bool? isFavourite;

  factory UserElement.fromJson(Map<String, dynamic> json) => UserElement(
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        email: json["email"],
        firstName: json["first_name"],
        id: json["id"],
        lastName: json["last_name"],
        bio: json["bio"],
        isFavourite: json["isFavourite"] == 0 || json["isFavourite"] == null
            ? false
            : true,
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt?.toIso8601String(),
        "email": email,
        "first_name": firstName,
        "id": id,
        "last_name": lastName,
        "bio": bio,
        "updated_at": updatedAt?.toIso8601String(),
        "isFavourite": isFavourite,
      };

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      "email": email,
      "first_name": firstName,
      "id": id,
      "last_name": lastName,
      "bio": bio,
      "isFavourite": isFavourite == true ? 1 : 0,
    };
    return map;
  }
}
