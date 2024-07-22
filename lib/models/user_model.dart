// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) => List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
    final String id;
    final String name;
    final String username;
    final String email;
    final String bio;
    final dynamic links;
    final String phone;
    final String image;
    final String token;
    final DateTime ?createdAt;
    final DateTime ?updatedAt;

    UserModel({
        required this.id,
        required this.name,
        required this.username,
        required this.email,
        required this.bio,
        required this.links,
        required this.phone,
        required this.image,
        required this.token,
         this.createdAt,
         this.updatedAt,
    });

    UserModel copyWith({
        String? id,
        String? name,
        String? username,
        String? email,
        String? bio,
        dynamic links,
        String? phone,
        String? image,
        String? token,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        UserModel(
            id: id ?? this.id,
            name: name ?? this.name,
            username: username ?? this.username,
            email: email ?? this.email,
            bio: bio ?? this.bio,
            links: links ?? this.links,
            phone: phone ?? this.phone,
            image: image ?? this.image,
            token: token ?? this.token,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        email: json["email"],
        bio: json["bio"],
        links: json["links"],
        phone: json["phone"],
        image: json["image"],
        token: json["token"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "email": email,
        "bio": bio,
        "links": links,
        "phone": phone,
        "image": image,
        "token": token,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
    };
}
