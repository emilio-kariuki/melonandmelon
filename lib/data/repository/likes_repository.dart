import 'dart:convert';

import 'package:melonandmelon/main.dart';
import 'package:melonandmelon/utilities/packages.dart';

abstract class LikesTemplate {
  Future<bool> likePost({required String postId});
  Future<bool> unlikePost({required String postId});
  Future<bool> likeComment({required String commentId});
  Future<bool> unlikeComment({required String commentId});
}

class LikesRepository extends LikesTemplate {
  final dio = Dio();
  @override
  Future<bool> likePost({required String postId}) async {
    try {
      // final id = supabase.auth.currentUser!.id;
      final id = APP_USER;
      final data = {
        'userId': id,
        'postId': postId,
      };
      final request = jsonEncode(data);
      final response = await dio.post("$API_URL/api/likes/add",
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
      logger.e(e);
      return false;
    }
  }

  @override
  Future<bool> unlikePost({required String postId}) async {
    try {
      // final id = supabase.auth.currentUser!.id;
      final id = APP_USER;
      final data = {
        'userId': id,
        'postId': postId,
      };
      final request = jsonEncode(data);
      final response = await dio.post("$API_URL/api/likes/remove",
          data: request,
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
            },
          ));
      logger.d(response);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  @override
  Future<bool> likeComment({required String commentId}) async {
    try {
      // final id = supabase.auth.currentUser!.id;
      final id = APP_USER;
      final data = {
        'userId': id,
        'commentId': commentId,
      };
      final request = jsonEncode(data);
      final response = await dio.post("$API_URL/api/comment/user/like",
          data: request,
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
            },
          ));

      logger.d(response);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  @override
  Future<bool> unlikeComment({required String commentId}) async {
    try {
      // final id = supabase.auth.currentUser!.id;
      final id = APP_USER;
      final data = {
        'userId': id,
        'commentId': commentId,
      };
      final request = jsonEncode(data);
      final response = await dio.post("$API_URL/api/comment/user/unlike",
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
      logger.e(e);
      return false;
    }
  }
}
