import 'dart:convert';

import 'package:melonandmelon/models/post_model.dart';
import 'package:melonandmelon/utilities/packages.dart';

abstract class PostTemplate {
  Future<bool> createPost({required PostModel post});
  Future<PostModel> getPost({required String id});
  Future<bool> updatePost({required PostModel post});
  Future<bool> deletePost({required String id});
  Future<List<PostModel>> getPosts();
}

class PostRepository extends PostTemplate {
  final dio = Dio();
  @override
  Future<bool> createPost({required PostModel post}) async {
    try {
      final data = {
        'id': post.id,
        'content': post.content,
        'image': post.image,
        'userId': post.userId,
      };
      final request = jsonEncode(data);
      final response = await dio.post("$API_URL/api/post/create",
          data: request,
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
            },
          ));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error creating post');
    }
  }

  @override
  Future<PostModel> getPost({required String id}) async {
    try {
      final response = await dio.get("$API_URL/api/post/get/$id",
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
              "user": supabase.auth.currentUser!.id
            },
          ));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.data);
        return PostModel.fromJson(data);
      } else {
        throw Exception('Error getting post');
      }
    } catch (e) {
      throw Exception('Error getting post');
    }
  }

  @override
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await dio.get("$API_URL/api/post/get",
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
              "user": supabase.auth.currentUser!.id
            },
          ));
      
      if (response.statusCode == 200) {
        return List<PostModel>.from(response.data.map((x) => PostModel.fromJson(x)));
      } else {
        throw Exception('Error getting posts');
      }
    } catch (e) {
      throw Exception('Error getting posts');
    }
  }

  @override
  Future<bool> updatePost({required PostModel post}) async {
    try {
      final data = {
        'content': post.content,
        'image': post.image,
      };
      final request = jsonEncode(data);
      final response = await dio.put("$API_URL/api/post/update/${post.id}",
          data: request,
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
              "user": supabase.auth.currentUser!.id
            },
          ));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error updating post');
    }
  }

  @override
  Future<bool> deletePost({required String id}) async {
    try {
      final response = await dio.delete("$API_URL/api/post/delete/$id",
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
              "user": supabase.auth.currentUser!.id
            },
          ));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error deleting post');
    }
  }
}
