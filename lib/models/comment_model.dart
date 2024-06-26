// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

import 'package:melonandmelon/models/user_model.dart';

List<CommentModel> commentModelFromJson(String str) => List<CommentModel>.from(json.decode(str).map((x) => CommentModel.fromJson(x)));

String commentModelToJson(List<CommentModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentModel {
    final String? id;
    final String? content;
    final String? postId;
    final String? userId;
    final int? likes;
    final dynamic reply;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final UserModel? user;

    CommentModel({
        this.id,
        this.content,
        this.postId,
        this.userId,
        this.likes,
        this.reply,
        this.createdAt,
        this.updatedAt,
        this.user,
    });

    CommentModel copyWith({
        String? id,
        String? content,
        String? postId,
        String? userId,
        int? likes,
        dynamic reply,
        DateTime? createdAt,
        DateTime? updatedAt,
        UserModel? user,
    }) => 
        CommentModel(
            id: id ?? this.id,
            content: content ?? this.content,
            postId: postId ?? this.postId,
            userId: userId ?? this.userId,
            likes: likes ?? this.likes,
            reply: reply ?? this.reply,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            user: user ?? this.user,
        );

    factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["id"],
        content: json["content"],
        postId: json["postId"],
        userId: json["userId"],
        likes: json["likes"],
        reply: json["reply"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "postId": postId,
        "userId": userId,
        "likes": likes,
        "reply": reply,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
    };
}
