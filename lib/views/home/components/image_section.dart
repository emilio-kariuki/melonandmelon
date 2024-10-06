import 'package:melonandmelon/blocs/app/likes_cubit.dart';
import 'package:melonandmelon/blocs/app/post_cubit.dart';
import 'package:melonandmelon/models/post_model.dart';
import 'package:melonandmelon/shared/image_container.dart';
import 'package:melonandmelon/utilities/packages.dart';
import 'package:melonandmelon/views/home/components/comment_sheet.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class ImageSection extends StatefulWidget {
  const ImageSection({super.key, required this.post, required this.index});

  final PostModel post;
  final int index;

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection>
    with AutomaticKeepAliveClientMixin<ImageSection> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => LikesCubit(),
      child: ChangeNotifierProvider(
        create: (context) => PageProvider(),
        child: Builder(builder: (context) {
          var pageProvider = Provider.of<PageProvider>(context);
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.4,
                    child: PageView.builder(
                      clipBehavior: Clip.none,
                      controller: _pageController,
                      itemCount: widget.post.image!.length,
                      itemBuilder: (context, imgIndex) {
                        return ImageContainer(
                          imageUrl: widget.post.image![imgIndex],
                          height: size.height * 0.7,
                          width: size.width,
                          borderRadius: BorderRadius.circular(0),
                          fit: BoxFit.cover,
                        );
                      },
                      onPageChanged: (value) =>
                          pageProvider.changePage(page: value),
                    ),
                  ),
                  _buildBottomAlignedWidgets(
                      context, widget.post, widget.index),
                  Gap(2 * SizeConfig.heightMultiplier),
                ],
              ),
              _buildTopAlignedWidgets(widget.post, pageProvider.page, context),
            ],
          );
        }),
      ),
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}

void handleLikeTap(BuildContext context, post, int index) {
  final postState = context.read<PostCubit>().state;
  int likes = post.likes;
  bool isLiked = post.isLiked;

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

Widget _buildBottomAlignedWidgets(
    BuildContext context, PostModel post, int index) {
  var pageProvider = Provider.of<PageProvider>(context);

  return Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 15,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gap(0.1 * SizeConfig.heightMultiplier),
        Center(
          child: DotsIndicator(
            dotsCount: post.image!.isEmpty ? 1 : post.image!.length,
            position: pageProvider.page,
            decorator: const DotsDecorator(
              color: darkWhite,
              activeColor: green,
              size: Size(5, 5),
              activeSize: Size(5, 5),
              spacing: EdgeInsets.symmetric(horizontal: 2.5),
            ),
            onTap: (position) => pageProvider.changePage(page: position),
          ),
        ),
        Gap(1.5 * SizeConfig.heightMultiplier),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () => handleLikeTap(context, post, index),
                child: _buildLikeButton(context, post)),
            Gap(3 * SizeConfig.widthMultiplier),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return CommentSheet(id: post.id);
                },
              ),
              child: _buildCommentButton(post),
            ),
            Gap(3 * SizeConfig.widthMultiplier),
            SvgPicture.asset(
              AppImages.share,
              height: 3.3 * SizeConfig.heightMultiplier,
              width: 3.3 * SizeConfig.heightMultiplier,
              color: white,
            ),
            const Spacer(),
            SvgPicture.asset(
              AppImages.save,
              height: 3.3 * SizeConfig.heightMultiplier,
              width: 3.3 * SizeConfig.heightMultiplier,
              color: white,
            ),
          ],
        ),
        Gap(2 * SizeConfig.heightMultiplier),
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
      ],
    ),
  );
}

Widget _buildTopAlignedWidgets(post, int page, context) {
  final size = MediaQuery.of(context).size;
  return Positioned.fill(
    top: 10,
    child: Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageContainer(
              imageUrl: post.user?.image ?? AppImages.defaultImage,
              height: size.height * 0.04,
              width: size.height * 0.04,
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
                    fontSize: 1.6 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w600,
                    color: white,
                    height: 1,
                  ),
                ),
                Gap(0.3 * SizeConfig.heightMultiplier),
                Text(
                  post.createdAt.toString().timeAgo(),
                  style: GoogleFonts.inter(
                    fontSize: 1.3 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w500,
                    color: white,
                  ),
                )
              ],
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
    ),
  );
}

Widget _buildLikeButton(BuildContext context, post) {
  return Row(
    children: [
      SvgPicture.asset(
        post.isLiked ? AppImages.favouriteSolid : AppImages.favourite,
        height: 3 * SizeConfig.heightMultiplier,
        width: 3 * SizeConfig.heightMultiplier,
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
        height: 3 * SizeConfig.heightMultiplier,
        width: 3 * SizeConfig.heightMultiplier,
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

class PageProvider with ChangeNotifier {
  int _page = 0;

  int get page => _page;

  void changePage({required int page}) {
    _page = page;
    notifyListeners();
  }
}
