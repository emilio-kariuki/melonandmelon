import 'package:melonandmelon/blocs/app/comment_cubit.dart';
import 'package:melonandmelon/blocs/app/likes_cubit.dart';
import 'package:melonandmelon/blocs/app/post_cubit.dart';
import 'package:melonandmelon/blocs/minimal/page_cubit.dart';
import 'package:melonandmelon/main.dart';
import 'package:melonandmelon/models/comment_request.dart';
import 'package:melonandmelon/shared/image_containe.dart';
import 'package:melonandmelon/shared/loading_circle.dart';
import 'package:melonandmelon/utilities/packages.dart';
import 'package:readmore/readmore.dart';

import '../../data/repository/socket_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    socket.connect();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: black,
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, postState) {
          switch (postState.status) {
            case PostStatus.loading:
              return const LoadingCircle();
            case PostStatus.success:
              return ListView.separated(
  controller: _scrollController,
  cacheExtent: 1000,
  shrinkWrap: true,
  physics: const BouncingScrollPhysics(),
  itemBuilder: (context, index) {
    final posts = context.read<PostCubit>().state.posts;
    final post = posts[index];
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PageCubit()),
        BlocProvider(create: (context) => LikesCubit()),
      ],
      child: Builder(builder: (context) {
        int page = 0;

        return Stack(
          children: [
            BlocConsumer<PageCubit, PageState>(
              listener: (context, pageState) {
                if (pageState.status == PageStatus.changed) {
                  page = pageState.page;
                }
              },
              builder: (context, pageState) {
                final pageController = PageController();
                return SizedBox(
                  height: size.height * 0.7,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: post.image!.length,
                    itemBuilder: (context, imgIndex) {
                      return ImageContainer(
                        imageUrl: post.image![imgIndex],
                        height: size.height * 0.7,
                        width: size.width,
                        // fit: BoxFit.contain,
                        borderRadius: BorderRadius.circular(0),
                      );
                    },
                    onPageChanged: (value) => context.read<PageCubit>().changePage(page: value),
                  ),
                );
              },
            ),
            _buildTopAlignedWidgets(post, page),
            _buildBottomAlignedWidgets(context, post, index)
          ],
        );
      }),
    );
  },
  separatorBuilder: (_, __) => Gap(0.1 * SizeConfig.heightMultiplier),
  itemCount: context.watch<PostCubit>().state.posts.length,
);
            default:
              return const LoadingCircle();
          }
        },
      ),
    );
  }
  Widget _buildTopAlignedWidgets(post, int page) {
  return Positioned.fill(
    top: 10,
    child: Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          BlocBuilder<PageCubit, PageState>(
            builder: (context, pageState) {
              return DotsIndicator(
                dotsCount: post.image!.length,
                position: page,
                decorator: const DotsDecorator(
                  color: darkWhite,
                  activeColor: green,
                  size: Size(5, 5),
                  activeSize: Size(5, 5),
                  spacing: EdgeInsets.symmetric(horizontal: 2),
                ),
                onTap: (position) => context.read<PageCubit>().changePage(page: position),
              );
            },
          ),
          Gap(1 * SizeConfig.heightMultiplier),
          _buildUserSection(post),
        ],
      ),
    ),
  );
}

Widget _buildUserSection(post) {
  final size = MediaQuery.sizeOf(context);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        ImageContainer(
          imageUrl: post.user?.image ?? AppImages.defaultImage,
          height: size.height * 0.06,
          width: size.height * 0.06,
          isCirlce: true,
        ),
        Gap(1 * SizeConfig.widthMultiplier),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              post.user?.name ?? "",
              style: GoogleFonts.inter(
                fontSize: 1.8 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w600,
                color: darkWhite,
                height: 1,
              ),
            ),
            Text(
              post.createdAt.toString().timeAgo(),
              style: GoogleFonts.inter(
                fontSize: 1.6 * SizeConfig.textMultiplier,
                fontWeight: FontWeight.w500,
                color: darkWhite,
              ),
            )
          ],
        )
      ],
    ),
  );
}

Widget _buildBottomAlignedWidgets(BuildContext context, post, int index) {
  return Positioned.fill(
    bottom: 1 * SizeConfig.heightMultiplier,
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ReadMoreText(
              post.content,
              trimMode: TrimMode.Line,
              trimLines: 2,
              colorClickableText: Colors.pink,
              trimCollapsedText: 'more',
              trimExpandedText: ' less',
              style: GoogleFonts.notoSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.1,
                color: white,
              ),
              lessStyle: const TextStyle(
                fontSize: 12,
                height: 1.1,
                fontWeight: FontWeight.bold,
                color: green,
              ),
              moreStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                height: 1.1,
                color: white,
              ),
            ),
            Gap(2 * SizeConfig.heightMultiplier),
            GestureDetector(
              onTap: () => _handleLikeTap(context, post, index),
              child: Row(
                children: [
                  _buildLikeButton(context, post),
                  Gap(3 * SizeConfig.widthMultiplier),
                  GestureDetector(
                    // onTap: () => _showCommentsSheet(context, post.id),
                    child: _buildCommentButton(post),
                  ),
                  Gap(3 * SizeConfig.widthMultiplier),
                  SvgPicture.asset(
                    AppImages.share,
                    height: 2.8 * SizeConfig.heightMultiplier,
                    width: 2.8 * SizeConfig.heightMultiplier,
                    color: white,
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    AppImages.more,
                    height: 3.8 * SizeConfig.heightMultiplier,
                    width: 3.8 * SizeConfig.heightMultiplier,
                    color: white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _handleLikeTap(BuildContext context, post, int index) {
  final postState = context.read<PostCubit>().state;
  int likes = post.likes;
  bool isLiked = post.isLiked;

  logger.d('Post Liked');
  final updatedPost = post.copyWith(
    isLiked: !isLiked,
    likes: isLiked ? likes - 1 : likes + 1,
  );

  postState.posts[index] = updatedPost;
  context.read<PostCubit>().rebuild();

  if (isLiked) {
    context.read<LikesCubit>().unlikePost(postId: post.id);
  } else {
    context.read<LikesCubit>().likePost(postId: post.id);
  }
}

Widget _buildLikeButton(BuildContext context, post) {
  return Row(
    children: [
      SvgPicture.asset(
        post.isLiked ? AppImages.favouriteSolid : AppImages.favourite,
        height: 2.6 * SizeConfig.heightMultiplier,
        width: 2.6 * SizeConfig.heightMultiplier,
        color: post.isLiked ? red : white,
      ),
      Gap(1 * SizeConfig.widthMultiplier),
      Text(
        post.likes.toString(),
        style: GoogleFonts.quicksand(
          fontSize: 1.8 * SizeConfig.textMultiplier,
          fontWeight: FontWeight.w700,
          color: white,
        ),
      )
    ],
  );
}

Widget _buildCommentButton(post) {
  return Row(
    children: [
      SvgPicture.asset(
        AppImages.message,
        height: 2.6 * SizeConfig.heightMultiplier,
        width: 2.6 * SizeConfig.heightMultiplier,
        color: white,
      ),
      Gap(1 * SizeConfig.widthMultiplier),
      Text(
        post.comments.toString(),
        style: GoogleFonts.quicksand(
          fontSize: 1.8 * SizeConfig.textMultiplier,
          fontWeight: FontWeight.w700,
          color: white,
        ),
      ),
    ],
  );
}

}

class CommentSheet extends StatelessWidget {
  CommentSheet({
    super.key,
    required this.id,
  });

  final String id;
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => CommentCubit()..getComments(postId: id),
        ),
        BlocProvider(
          create: (context) => LikesCubit(),
          lazy: false,
        ),
      ],
      child: Container(
          height: size.height * 0.5,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding:
              EdgeInsets.symmetric(vertical: 5 * SizeConfig.heightMultiplier),
          decoration: const BoxDecoration(
            color: black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: BlocConsumer<CommentCubit, CommentState>(
            listenWhen: (previous, current) =>
                previous.comments != current.comments,
            buildWhen: (previous, current) =>
                previous.comments != current.comments,
            listener: (context, state) {},
            builder: (context, commentState) {
              if (commentState.status == CommentStatus.loading) {
                return const LoadingCircle();
              } else if (commentState.status == CommentStatus.error) {
                return Center(
                  child: Text(
                    commentState.message,
                    style: GoogleFonts.inter(
                      fontSize: 2 * SizeConfig.textMultiplier,
                      color: white,
                    ),
                  ),
                );
              }
              // socket.on('commentCreated', (value) {
              //   logger.d("receive the message");
              //   context.read<CommentCubit>().getComments(postId: id);
              // });
              return Scaffold(
                backgroundColor: Colors.transparent,
                bottomNavigationBar: Container(
                  color: black,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 6 * SizeConfig.heightMultiplier,
                    ),
                    child: Row(
                      children: [
                        Gap(1 * SizeConfig.widthMultiplier),
                        Expanded(
                          child: TextFormField(
                            controller: _commentController,
                            textInputAction: TextInputAction.send,
                            keyboardType: TextInputType.multiline,
                            maxLines: 15,
                            minLines: 1,
                            style: GoogleFonts.inter(
                              color: white,
                              fontSize: 1.6 * SizeConfig.textMultiplier,
                            ),
                            onFieldSubmitted: (value) {
                              final data = CommentRequest(
                                  content: _commentController.text,
                                  postId: id,
                                  userId: APP_USER);
                              context
                                  .read<CommentCubit>()
                                  .addComment(comment: data);
                              _commentController.clear();
                            },
                            decoration: InputDecoration(
                              hintText: 'Add a comment',
                              hintStyle: GoogleFonts.inter(
                                color: const Color(0xff777777),
                                fontSize: 1.6 * SizeConfig.textMultiplier,
                              ),
                              fillColor: const Color(0xff232323),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(30)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                            ),
                          ),
                        ),
                        Gap(1 * SizeConfig.widthMultiplier),
                        GestureDetector(
                          onTap: () {
                            final data = CommentRequest(
                                content: _commentController.text,
                                postId: id,
                                userId: APP_USER);
                            context
                                .read<CommentCubit>()
                                .addComment(comment: data);
                            _commentController.clear();
                          },
                          child: SvgPicture.asset(
                            AppImages.send,
                            height: 3 * SizeConfig.heightMultiplier,
                            width: 3 * SizeConfig.heightMultiplier,
                            color: white,
                          ),
                        ),
                        Gap(1 * SizeConfig.widthMultiplier),
                      ],
                    ),
                  ),
                ),
                body: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 2 * SizeConfig.widthMultiplier, vertical: 10),
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ImageContainer(
                                imageUrl:
                                    commentState.comments[index].user?.image ??
                                        AppImages.defaultImage,
                                height: size.height * 0.04,
                                width: size.height * 0.04,
                                isCirlce: true,
                              ),
                              Gap(1.5 * SizeConfig.widthMultiplier),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        commentState
                                                .comments[index].user?.name ??
                                            "",
                                        style: TextStyle(
                                            fontSize:
                                                1.5 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w600,
                                            color: darkWhite,
                                            height: 1),
                                      ),
                                      Gap(1 * SizeConfig.widthMultiplier),
                                      Text(
                                        commentState.comments[index].createdAt
                                            .toString()
                                            .timeAgo(),
                                        style: GoogleFonts.inter(
                                          fontSize:
                                              1.2 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w300,
                                          color: darkWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(1 * SizeConfig.heightMultiplier),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: size.width * 0.7),
                                    child: Text(
                                      commentState.comments[index].content ??
                                          "",
                                      maxLines: 10,
                                      style: GoogleFonts.inter(
                                          fontSize:
                                              1.6 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w500,
                                          color: darkWhite,
                                          height: 1),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  int likes =
                                      commentState.comments[index].likes;
                                  bool isLiked =
                                      commentState.comments[index].isLiked;

                                  final updatedComment =
                                      commentState.comments[index].copyWith(
                                    isLiked: !isLiked,
                                    likes: isLiked ? likes - 1 : likes + 1,
                                  );
                                  commentState.comments[index] = updatedComment;
                                  context.read<CommentCubit>().rebuild();
                                  isLiked
                                      ? context
                                          .read<LikesCubit>()
                                          .unlikeComment(
                                              commentId: commentState
                                                  .comments[index].id)
                                      : context.read<LikesCubit>().likeComment(
                                          commentId:
                                              commentState.comments[index].id);
                                },
                                child: BlocBuilder<CommentCubit, CommentState>(
                                  builder: (context, state) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          commentState.comments[index].isLiked
                                              ? AppImages.favouriteSolid
                                              : AppImages.favourite,
                                          height:
                                              2 * SizeConfig.heightMultiplier,
                                          width:
                                              2 * SizeConfig.heightMultiplier,
                                          color: commentState
                                                  .comments[index].isLiked
                                              ? red
                                              : const Color.fromARGB(
                                                  255, 61, 61, 61),
                                        ),
                                        Text(
                                          commentState.comments[index].likes
                                              .toString(),
                                          style: GoogleFonts.quicksand(
                                            fontSize:
                                                1.8 * SizeConfig.textMultiplier,
                                            fontWeight: FontWeight.w700,
                                            color: const Color.fromARGB(
                                                255, 61, 61, 61),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                      separatorBuilder: (context, index) =>
                          Gap(2 * SizeConfig.heightMultiplier),
                      itemCount: commentState.comments.length),
                ),
              );
            },
          )),
    );
  }
}
