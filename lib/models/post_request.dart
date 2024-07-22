// To parse this JSON data, do
//
//     final postRequestModel = postRequestModelFromJson(jsonString);

import 'dart:convert';

PostRequestModel postRequestModelFromJson(String str) => PostRequestModel.fromJson(json.decode(str));

String postRequestModelToJson(PostRequestModel data) => json.encode(data.toJson());

class PostRequestModel {
    final String content;
    final List<String> image;

    PostRequestModel({
        required this.content,
        required this.image,
    });

    PostRequestModel copyWith({
        String? content,
        List<String>? image,
    }) => 
        PostRequestModel(
            content: content ?? this.content,
            image: image ?? this.image,
        );

    factory PostRequestModel.fromJson(Map<String, dynamic> json) => PostRequestModel(
        content: json["content"],
        image: List<String>.from(json["image"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "content": content,
        "image": List<dynamic>.from(image.map((x) => x)),
    };
}
