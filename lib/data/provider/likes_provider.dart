
import 'package:melonandmelon/data/repository/likes_repository.dart';

class LikesProvider extends LikesTemplate {
  final LikesRepository _likesRepository;
  LikesProvider({required LikesRepository likesRepository})
      : _likesRepository = likesRepository;

  @override
  Future<bool> likePost({required String postId}) {
    return _likesRepository.likePost(postId: postId);
  }

  @override
  Future<bool> unlikePost({required String postId}) {
    return _likesRepository.unlikePost(postId: postId);
  }
  
  @override
  Future<bool> likeComment({required String commentId}) {
    return _likesRepository.likeComment(commentId: commentId);
  }
  
  @override
  Future<bool> unlikeComment({required String commentId}) {
    return _likesRepository.unlikeComment(commentId: commentId);
  }
}