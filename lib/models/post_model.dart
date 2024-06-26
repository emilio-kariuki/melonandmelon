// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

import 'package:melonandmelon/models/user_model.dart';

List<PostModel> postModelFromJson(String str) =>
    List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));

String postModelToJson(List<PostModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PostModel {
  final String id;
  final String content;
  final List<String>? image;
  final String? userId;
  final int likes;
  final int? comments;
  final bool isLiked;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? user;

  PostModel({
    required this.id,
    required this.content,
    this.image,
    this.userId,
    required this.likes,
    this.comments,
    required this.isLiked,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  PostModel copyWith({
    String? id,
    String? content,
    List<String>? image,
    String? userId,
    int? likes,
    int? comments,
    bool? isLiked,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? user,
  }) =>
      PostModel(
        id: id ?? this.id,
        content: content ?? this.content,
        image: image ?? this.image,
        userId: userId ?? this.userId,
        likes: likes ?? this.likes,
        comments: comments ?? this.comments,
        isLiked: isLiked ?? this.isLiked,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        user: user ?? this.user,
      );

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        content: json["content"],
        image: json["image"] == null
            ? []
            : List<String>.from(json["image"]!.map((x) => x)),
        userId: json["userId"],
        likes: json["likes"],
        comments: json["comments"],
        isLiked: json["isLiked"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "image": image == null ? [] : List<dynamic>.from(image!.map((x) => x)),
        "userId": userId,
        "likes": likes,
        "comments": comments,
        "isLiked": isLiked,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
      };
}
