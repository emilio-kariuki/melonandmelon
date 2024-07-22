import 'dart:convert';

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
        "phone": user.phone ?? "",
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
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
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
        "phone": user.phone
      };
      final request = jsonEncode(data);
      final id = supabase.auth.currentUser!.id;
      final response = await dio.put("$API_URL/api/user/update/$id",
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
      throw Exception('Error updating user');
    }
  }

  @override
  Future<UserModel> getUser() async {
    try {
      // final id = supabase.auth.currentUser!.id;
      final id = APP_USER;
      final response = await dio.get("$API_URL/api/user/get/$id",
          options: Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "application/json",
            },
          ));
      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data);
        logger.d(user.username);
        return user;
      } else {
        throw Exception('Error getting user');
      }
    } catch (e) {
      logger.e(e);
      throw Exception('Error getting user');
    }
  }
}
