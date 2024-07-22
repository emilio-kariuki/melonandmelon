import 'package:melonandmelon/data/provider/likes_provider.dart';
import 'package:melonandmelon/data/repository/likes_repository.dart';
import 'package:melonandmelon/utilities/packages.dart';

class LikesCubit extends Cubit<CubitState> {
  LikesCubit() : super(CubitState());

  final _likesService = LikesProvider(likesRepository: LikesRepository());

  Future<void> likePost({required String postId}) async {
    try {
      emit(state.copyWith(
        status: LikesStatus.loading,
        message: "Liking post...",
      ));
      final response = await _likesService.likePost(postId: postId);
      if (!response) {
        emit(state.copyWith(
          status: LikesStatus.error,
          message: "Failed to like post",
        ));
        return;
      }
      emit(state.copyWith(
        status: LikesStatus.success,
        message: "Post liked",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LikesStatus.error,
        message: e.toString().toException(),
      ));
    }
  }

  Future<void> unlikePost({required String postId}) async {
    try {
      emit(state.copyWith(
        status: LikesStatus.loading,
        message: "Unliking post...",
      ));
      final response = await _likesService.unlikePost(postId: postId);
      if (!response) {
        emit(state.copyWith(
          status: LikesStatus.error,
          message: "Failed to unlike post",
        ));
        return;
      }
      emit(state.copyWith(
        status: LikesStatus.success,
        message: "Post unliked",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LikesStatus.error,
        message: e.toString().toException(),
      ));
    }
  }

  Future<void> likeComment({required String commentId}) async {
    try {
      emit(state.copyWith(
        status: LikesStatus.loading,
        message: "Liking comment...",
      ));
      final response = await _likesService.likeComment(commentId: commentId);
      if (!response) {
        emit(state.copyWith(
          status: LikesStatus.error,
          message: "Failed to like comment",
        ));
        return;
      }
      emit(state.copyWith(
        status: LikesStatus.success,
        message: "Comment liked",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LikesStatus.error,
        message: e.toString().toException(),
      ));
    }
  }

  Future<void> unlikeComment({required String commentId}) async {
    try {
      emit(state.copyWith(
        status: LikesStatus.loading,
        message: "Unliking comment...",
      ));
      final response = await _likesService.unlikeComment(commentId: commentId);
      if (!response) {
        emit(state.copyWith(
          status: LikesStatus.error,
          message: "Failed to unlike comment",
        ));
        return;
      }
      emit(state.copyWith(
        status: LikesStatus.success,
        message: "Comment unliked",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LikesStatus.error,
        message: e.toString().toException(),
      ));
    }
  }

}

enum LikesStatus { initial, loading, success, error }

class CubitState {
  final LikesStatus status;
  final String message;

  CubitState({
    this.status = LikesStatus.initial,
    this.message = "",
  });

  CubitState copyWith({
    LikesStatus? status,
    String? message,
  }) {
    return CubitState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}