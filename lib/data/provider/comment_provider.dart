import 'package:melonandmelon/data/repository/comment_repository.dart';
import 'package:melonandmelon/models/comment_model.dart';
import 'package:melonandmelon/models/comment_request.dart';

class CommentProvider extends CommentTemplate {
  final CommentRepository _commentRepository;
  CommentProvider({required CommentRepository commentRepository})
      : _commentRepository = commentRepository;

  @override
  Future<bool> createComment({required CommentRequest comment}) {
    return _commentRepository.createComment(comment: comment);
  }

  @override
  Future<bool> deleteComment({required String id}) {
    return _commentRepository.deleteComment(id: id);
  }

  @override
  Future<List<CommentModel>> getPostComments({required String postId}) {
    return _commentRepository.getPostComments(postId: postId);
  }
  
  @override
  Future<List<CommentModel>> getUserComments() {
    return _commentRepository.getUserComments();
  }
  
  @override
  Future<bool> updateComment({required CommentModel comment}) {
    return _commentRepository.updateComment(comment: comment);
  }
}