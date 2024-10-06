import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:melonandmelon/main.dart';
import 'package:melonandmelon/models/user_model.dart';
import 'package:melonandmelon/utilities/packages.dart';

abstract class UserTemplate {
  Future<bool> createUser({required UserModel user});
  Future<bool> updateUser({
    required UserModel user,
  });
  Future<UserModel> getUser();
}

class UserRepository extends UserTemplate {
  final dio = Dio();
  @override
  Future<bool> createUser({required UserModel user}) async {
    try {
      final data = {
        "id": user.id,
        "email": user.email,
        "name": user.name,
        "image": user.image,
        "phone": user.phone,
        "token": user.token,
      };
      final request = jsonEncode(data);
      final response = await dio.post("$API_URL/api/user/create",
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
      logger.e(e);
      throw Exception('Error creating user');
    }
  }

  @override
  Future<bool> updateUser({required UserModel user}) async {
    try {
      final data = {
        "email": user.email,
        "name": user.name,
        "image": user.image,
        "phone": user.phone,
        "bio": user.bio,
      };
      final request = jsonEncode(data);
      // final id = supabase.auth.currentUser!.id;
      const id = APP_USER;
      final response = await dio.put("$API_URL/api/user/update/$id",
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
      logger.e(e);
      throw Exception('Error updating user');
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      // final id = supabase.auth.currentUser!.id;
      const id = APP_USER;
      final response = await dio.get("$API_URL/api/user/get/$id",
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
            },
          ));
        logger.d("user response: ${response.data}");
      if (response.statusCode != 200) {
        throw Exception('Error getting user');
      }

      final user = UserModel.fromJson(response.data);
      return user;
    } catch (e) {
      logger.e(e);
      throw Exception('Error getting user');
    }
  }
}
