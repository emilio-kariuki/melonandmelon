import 'package:melonandmelon/data/provider/comment_provider.dart';
import 'package:melonandmelon/data/repository/comment_repository.dart';
import 'package:melonandmelon/models/comment_model.dart';
import 'package:melonandmelon/models/comment_request.dart';
import 'package:melonandmelon/utilities/packages.dart';

class CommentCubit extends Cubit<CommentState> {
  CommentCubit() : super(CommentState());

  final _commentProvider = CommentProvider(commentRepository: CommentRepository());

  Future<void> getComments({required String postId}) async {
    try {
      emit(state.copyWith(
        status: CommentStatus.loading,
        message: "Fetching comments...",
      ));
      final comments = await _commentProvider.getPostComments(postId: postId);
      emit(state.copyWith(
        status: CommentStatus.success,
        comments: comments,
        message: "Comments fetched successfully",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CommentStatus.error,
        message: e.toString().toException(),
      ));
    }
  }

  Future<void> addComment({required CommentRequest comment}) async {
    try {
      emit(state.copyWith(
        status: CommentStatus.loading,
        message: "Adding comment...",
      ));
      final response = await _commentProvider.createComment(comment: comment);
      if (!response) {
        emit(state.copyWith(
          status: CommentStatus.error,
          message: "Failed to add comment",
        ));
        return;
      }
      getComments(postId: comment.postId!);
      emit(state.copyWith(
        status: CommentStatus.success,
        message: "Comment added",
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CommentStatus.error,
        message: e.toString().toException(),
      ));
    }
  }

  rebuild() => emit(state.copyWith(status: CommentStatus.success));

}

enum CommentStatus { initial, loading, success, error }

class CommentState {
  final CommentModel? comment;
  final List<CommentModel> comments;
  final CommentStatus status;
  final String message;

  CommentState({
    this.comment,
    this.status = CommentStatus.initial,
    this.comments = const [],
    this.message = "",
  });

  CommentState copyWith({
    CommentModel? comment,
    CommentStatus? status,
    List<CommentModel>? comments,
    String? message,
  }) {
    return CommentState(
      comment: comment ?? this.comment,
      comments: comments ?? this.comments,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}