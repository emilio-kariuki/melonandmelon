import 'dart:io';

import 'package:melonandmelon/data/repository/app_repository.dart';
import 'package:melonandmelon/utilities/packages.dart';
import 'package:melonandmelon/utilities/utilities.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState());

  Future<void> uploadImage() async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      final imageUrl = await AppRepository().uploadImage(
        file: state.imageFile!,
      );
      emit(state.copyWith(
        status: AppStatus.uploaded,
        imageUrl: imageUrl,
        message: "Image uploaded successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: AppStatus.error,
        message: error.toString().toException(),
      ));
    }
  }

  Future<void> pickImage({required ImageSource source}) async {
    try {
      final imageFile = await AppRepository().pickImage(source: source);
      emit(state.copyWith(
        status: AppStatus.success,
        imageFile: imageFile,
        message: "Image picked successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: AppStatus.error,
        message: error.toString().toException(),
      ));
    }
  }
}

enum AppStatus { initial, loading, success,uploaded, error }

class AppState {
  final AppStatus status;
  final String imageUrl;
  final File? imageFile;
  final String message;

  AppState({
    this.status = AppStatus.initial,
    this.imageUrl = "",
    this.imageFile,
    this.message = "",
  });

  AppState copyWith({
    AppStatus? status,
    String? message,
    String? imageUrl,
    File? imageFile,
  }) {
    return AppState(
      status: status ?? this.status,
      message: message ?? this.message,
      imageUrl: imageUrl ?? this.imageUrl,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}
