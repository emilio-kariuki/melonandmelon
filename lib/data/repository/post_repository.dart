import 'dart:convert';

import 'package:melonandmelon/main.dart';
import 'package:melonandmelon/models/post_model.dart';
import 'package:melonandmelon/models/post_request.dart';
import 'package:melonandmelon/utilities/packages.dart';
import 'package:dio/dio.dart';


abstract class PostTemplate {
  Future<bool> createPost({required PostRequestModel post});
  Future<PostModel> getPost({required String id});
  Future<bool> updatePost({required PostModel post});
  Future<bool> deletePost({required String id});
  Future<List<PostModel>> getPosts();
  Future<List<PostModel>> getUserPosts();
}

class PostRepository extends PostTemplate {
  final dio = Dio();
  @override
  Future<bool> createPost({required PostRequestModel post}) async {
    logger.d(post.image);
    try {
      final data = {
        'content': post.content,
        'image': post.image,
      };
      final request = jsonEncode(data);
      final response = await dio.post("$API_URL/api/post/create",
          data: request,
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
              // "user": supabase.auth.currentUser!.id
              "user": APP_USER
            },
          ));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e(e);
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
              // "user": supabase.auth.currentUser!.id
              "user": APP_USER
            },
          ));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.data);
        return PostModel.fromJson(data);
      } else {
        throw Exception('Error getting post');
      }
    } catch (e) {
      logger.e(e);
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
              // "user": supabase.auth.currentUser!.id
              "user": APP_USER
            },
          ));
      if (response.statusCode != 200) {
        throw Exception('Error getting posts');
      }
      final data =  List<PostModel>.from(response.data.map((x) => PostModel.fromJson(x)));
      return data;
    } catch (e) {
      logger.e(e);
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
              // "user": supabase.auth.currentUser!.id
              "user": APP_USER
            },
          ));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e(e);
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
              // "user": supabase.auth.currentUser!.id
              "user": APP_USER
            },
          ));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e(e);
      throw Exception('Error deleting post');
    }
  }
  
  @override
  Future<List<PostModel>> getUserPosts() async{
    try{
      final userId = APP_USER;
      final response = await dio.get("$API_URL/api/post/user/$userId",
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
            },
          ));
      if(response.statusCode != 200){
        throw Exception('Error getting user posts');
      }
      final data =  List<PostModel>.from(response.data.map((x) => PostModel.fromJson(x)));
      return data;
    }catch(e){
      logger.e(e);
      throw Exception('Error getting user posts');
    }
  }
}
