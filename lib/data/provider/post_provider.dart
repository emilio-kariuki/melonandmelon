import 'package:melonandmelon/data/repository/post_repository.dart';
import 'package:melonandmelon/models/post_model.dart';
import 'package:melonandmelon/models/post_request.dart';

class PostProvider extends PostTemplate {
  final PostRepository _postRepository;
  PostProvider({required PostRepository postRepository})
      : _postRepository = postRepository;

  @override
  Future<bool> createPost({required PostRequestModel post}) {
    return _postRepository.createPost(post: post);
  }

  @override
  Future<bool> deletePost({required String id}) {
    return _postRepository.deletePost(id: id);
  }

  @override
  Future<PostModel> getPost({required String id}) {
    return _postRepository.getPost(id: id);
  }

  @override
  Future<List<PostModel>> getPosts() {
    return _postRepository.getPosts();
  }

  @override
  Future<bool> updatePost({required PostModel post}) {
    return _postRepository.updatePost(post: post);
  }
  
  @override
  Future<List<PostModel>> getUserPosts() async{
    return _postRepository.getUserPosts();
  }
  
}