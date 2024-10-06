
import 'package:melonandmelon/blocs/app/comment_cubit.dart';
import 'package:melonandmelon/blocs/app/likes_cubit.dart';
import 'package:melonandmelon/models/comment_request.dart';
import 'package:melonandmelon/shared/image_container.dart';
import 'package:melonandmelon/shared/loading_circle.dart';
import 'package:melonandmelon/utilities/packages.dart';

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