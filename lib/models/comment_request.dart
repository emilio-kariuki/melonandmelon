// To parse this JSON data, do
//
//     final commentRequest = commentRequestFromJson(jsonString);

import 'dart:convert';

CommentRequest commentRequestFromJson(String str) => CommentRequest.fromJson(json.decode(str));

String commentRequestToJson(CommentRequest data) => json.encode(data.toJson());

class CommentRequest {
    final String? content;
    final String? postId;
    final String? userId;

    CommentRequest({
        this.content,
        this.postId,
        this.userId,
    });

    CommentRequest copyWith({
        String? content,
        String? postId,
        String? userId,
    }) => 
        CommentRequest(
            content: content ?? this.content,
            postId: postId ?? this.postId,
            userId: userId ?? this.userId,
        );

    factory CommentRequest.fromJson(Map<String, dynamic> json) => CommentRequest(
        content: json["content"],
        postId: json["postId"],
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "content": content,
        "postId": postId,
        "userId": userId,
    };
}
