import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:melonandmelon/main.dart';
import 'package:melonandmelon/utilities/packages.dart';
import 'package:dio/dio.dart' as diop;

abstract class AppTemplate {
  Future<File> pickImage({required ImageSource source});
  Future<String> uploadImage({required File file});
  Future<bool> deleteImage({required String url});
}

class AppRepository extends AppTemplate {
  final dio = diop.Dio();

  @override
  Future<File> pickImage({required ImageSource source}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        throw Exception('Error picking image');
      }
    } catch (e) {
      logger.e(e);
      throw Exception('Error picking image');
    }
  }

  @override
  Future<String> uploadImage({required File file}) async {
    logger.i("Uploading image");
    try {
      var formData = diop.FormData.fromMap({
        "file": await diop.MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last,
            contentType: MediaType('image', 'jpeg')
            ),
      },
      diop.ListFormat.multi
      );
      final response = await dio.post("$API_URL/api/upload/single",
          data: formData,
          options: diop.Options(
            headers: {
              "APIKEY": API_KEY,
              "Content-Type": "multipart/form-data",
              "mimetype": "image/jpeg",
            },
          ));
      if (response.statusCode != 200) {
        throw Exception('Error uploading image');
      }
      logger.d(response.data['image']);
      return response.data['image'];
    } catch (e) {
      logger.e(e);
      throw Exception('Error uploading image');
    }
  }

  @override
  Future<bool> deleteImage({required String url}) {
    // TODO: implement deleteImage
    throw UnimplementedError();
  }
}
