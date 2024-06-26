import 'dart:convert';

import 'package:melonandmelon/models/comment_model.dart';
import 'package:melonandmelon/models/comment_request.dart';
import 'package:melonandmelon/utilities/packages.dart';

abstract class CommentTemplate {
  Future<bool> createComment({required CommentRequest comment});
  Future<bool> updateComment({required CommentModel comment});
  Future<bool> deleteComment({required String id});
  Future<List<CommentModel>> getPostComments({required String postId});
  Future<List<CommentModel>> getUserComments();
}

class CommentRepository extends CommentTemplate {
  final dio = Dio();
  @override
  Future<bool> createComment({required CommentRequest comment}) async {
    try {
      final request = jsonEncode(comment.toJson());
      final response = await dio.post("$API_URL/api/comment/create",
          data: request,
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
            },
          ));

      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteComment({required String id}) async{
    try {
      final response = await dio.delete("$API_URL/api/comment/delete/$id",
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
            },
          ));
      if (response.statusCode != 200) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<CommentModel>> getPostComments({required String postId}) async{
    try {
      final response = await dio.get("$API_URL/api/comment/post/$postId",
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
            },
          ));
      if (response.statusCode != 200) {
        throw Exception('Error getting comments');
      }
      final data = jsonDecode(response.data);
      final List<CommentModel> comments = [];
      for (var item in data) {
        comments.add(CommentModel.fromJson(item));
      }
      return comments;
    } catch (e) {
      throw Exception('Error getting comments');
    }
  }
  
  @override
  Future<List<CommentModel>> getUserComments() async{
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await dio.get("$API_URL/api/comment/user/$userId",
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
            },
          ));
      if (response.statusCode != 200) {
        throw Exception('Error getting comments');
      }
      final data = jsonDecode(response.data);
      final List<CommentModel> comments = [];
      for (var item in data) {
        comments.add(CommentModel.fromJson(item));
      }
      return comments;
    } catch (e) {
      throw Exception('Error getting comments');
    }
  }
  
  @override
  Future<bool> updateComment({required CommentModel comment}) async{
    try{
      final request = jsonEncode(comment.toJson());
      final response = await dio.put("$API_URL/api/comment/update/${comment.id}",
          data: request,
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
            },
          ));
      if(response.statusCode != 200){
        return false;
      }
      return true;
    }catch(e){
      return false;
    }
  }
}
