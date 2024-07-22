import 'package:melonandmelon/data/provider/post_provider.dart';
import 'package:melonandmelon/data/service_locator.dart';
import 'package:melonandmelon/models/post_model.dart';
import 'package:melonandmelon/models/post_request.dart';
import 'package:melonandmelon/utilities/packages.dart';

class PostCubit extends Cubit<PostState> {
  final _postService = service<PostProvider>();
  PostCubit() : super(PostState());
  setLoading() => emit(state.copyWith(status: PostStatus.loading));

  Future<void> getPosts() async {
    try {
      setLoading();
      final posts = await _postService.getPosts();
      emit(state.copyWith(
        status: PostStatus.success,
        posts: posts,
        message: "Posts fetched successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: PostStatus.error,
        message: error.toString().toException(),
      ));
    }
  }

  Future<void> createPost({required PostRequestModel post}) async {
    try {
      setLoading();
      await _postService.createPost(post: post);
      emit(state.copyWith(
        status: PostStatus.created,
        message: "Post created successfully",
      ));
    } catch (error) {
      emit(state.copyWith(
        status: PostStatus.error,
        message: error.toString().toException(),
      ));
    }
  }

  rebuild() => emit(state.copyWith(status: PostStatus.success));
}

enum PostStatus { initial, loading, success,created, error }

class PostState {
  final PostModel? post;
  final List<PostModel> posts;
  final PostStatus status;
  final String message;

  PostState({
    this.post,
    this.status = PostStatus.initial,
    this.posts = const [],
    this.message = "",
  });

  PostState copyWith({
    PostModel? post,
    PostStatus? status,
    List<PostModel> ?posts,
    String? message,
  }) {
    return PostState(
      post: post ?? this.post,
      posts: posts ?? this.posts,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}