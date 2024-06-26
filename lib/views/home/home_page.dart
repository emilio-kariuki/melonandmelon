import 'package:melonandmelon/blocs/app/post_cubit.dart';
import 'package:melonandmelon/blocs/app/user_cubit.dart';
import 'package:melonandmelon/blocs/minimal/page_cubit.dart';
import 'package:melonandmelon/shared/image_containe.dart';
import 'package:melonandmelon/shared/loading_circle.dart';
import 'package:melonandmelon/utilities/packages.dart';
import 'package:readmore/readmore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<PostCubit, PostState>(
              builder: (context, postState) {
                switch (postState.status) {
                  case PostStatus.loading:
                    return LoadingCircle();
                  case PostStatus.success:
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return BlocProvider(
                          create: (context) => PageCubit(),
                          child: Builder(builder: (context) {
                            return Stack(
                              children: [
                                BlocConsumer<PageCubit, PageState>(
                                  listener: (context, pageState) {
                                    page = pageState.page;
                                  },
                                  builder: (context, pageState) {
                                    return CarouselSlider.builder(
                                      itemCount:
                                          postState.posts[index].image!.length,
                                      itemBuilder: (context, _, __) {
                                        return ImageContainer(
                                          imageUrl: postState
                                              .posts[index].image![page],
                                          height: size.height * 0.8,
                                          width: size.width,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        );
                                      },
                                      options: CarouselOptions(
                                          height: size.height * 0.7,
                                          aspectRatio: 16 / 9,
                                          viewportFraction: 1,
                                          autoPlayInterval:
                                              const Duration(milliseconds: 500),
                                          enableInfiniteScroll: false,
                                          autoPlayCurve: Curves.linear,
                                          animateToClosest: false,
                                          onScrolled: (value) {
                                            context
                                                .read<PageCubit>()
                                                .changePage(
                                                    page: value!.toInt());
                                          }),
                                    );
                                  },
                                ),
                                Positioned.fill(
                                    top: 10,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Column(
                                        children: [
                                          BlocBuilder<PageCubit, PageState>(
                                            builder: (context, pageState) {
                                              return DotsIndicator(
                                                  dotsCount: postState
                                                      .posts[index]
                                                      .image!
                                                      .length,
                                                  position: page,
                                                  decorator:
                                                      const DotsDecorator(
                                                          color: darkWhite,
                                                          activeColor: green,
                                                          size: Size(8, 8),
                                                          activeSize:
                                                              Size(8, 8),
                                                          spacing: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      3)),
                                                  onTap: (position) => context
                                                      .read<PageCubit>()
                                                      .changePage(
                                                          page: position));
                                            },
                                          ),
                                          Gap(1 * SizeConfig.heightMultiplier),
                                          BlocBuilder<UserCubit, UserState>(
                                            builder: (context, state) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                child: Row(
                                                  children: [
                                                    ImageContainer(
                                                      imageUrl:
                                                          state.user?.image ??
                                                              AppImages
                                                                  .defaultImage,
                                                      height:
                                                          size.height * 0.06,
                                                      width: size.height * 0.06,
                                                      isCirlce: true,
                                                    ),
                                                    Gap(1 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          state.user!.name ??
                                                              "",
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 1.8 *
                                                                SizeConfig
                                                                    .textMultiplier,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: darkWhite,
                                                          ),
                                                        ),
                                                        Text(
                                                          postState.posts[index]
                                                              .createdAt
                                                              .toString()
                                                              .timeAgo(),
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 1.6 *
                                                                SizeConfig
                                                                    .textMultiplier,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: darkWhite,
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                    )),
                                Positioned.fill(
                                    bottom: 1 * SizeConfig.heightMultiplier,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ReadMoreText(
                                              postState.posts[index].content,
                                              trimMode: TrimMode.Line,
                                              trimLines: 2,
                                              colorClickableText: Colors.pink,
                                              trimCollapsedText: 'more',
                                              trimExpandedText: 'less',
                                              style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: white),
                                                  lessStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: green),
                                              moreStyle: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: white),
                                            ),
                                            Gap(2 * SizeConfig.heightMultiplier),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                        postState.posts[index]
                                                                .isLiked
                                                            ? AppImages
                                                                .favouriteSolid
                                                            : AppImages
                                                                .favourite,
                                                        height: 2.6 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        width: 2.6 *
                                                            SizeConfig
                                                                .heightMultiplier,
                                                        color: postState
                                                                .posts[index]
                                                                .isLiked
                                                            ? red
                                                            : white),
                                                    Gap(1 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                    Text(
                                                      postState
                                                          .posts[index].likes
                                                          .toString(),
                                                      style: GoogleFonts.quicksand(
                                                          fontSize: 1.8 *
                                                              SizeConfig
                                                                  .textMultiplier,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: white),
                                                    )
                                                  ],
                                                ),
                                                Gap(3 *
                                                    SizeConfig.widthMultiplier),
                                                Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      AppImages.message,
                                                      height: 2.6 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      width: 2.6 *
                                                          SizeConfig
                                                              .heightMultiplier,
                                                      color: white,
                                                    ),
                                                    Gap(1 *
                                                        SizeConfig
                                                            .widthMultiplier),
                                                    Text(
                                                      postState
                                                          .posts[index].comments
                                                          .toString(),
                                                      style: GoogleFonts.quicksand(
                                                          fontSize: 1.8 *
                                                              SizeConfig
                                                                  .textMultiplier,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: white),
                                                    )
                                                  ],
                                                ),
                                                Gap(3 *
                                                    SizeConfig.widthMultiplier),
                                                SvgPicture.asset(
                                                  AppImages.share,
                                                  height: 2.8 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  width: 2.8 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  color: white,
                                                ),
                                                const Spacer(),
                                                SvgPicture.asset(
                                                  AppImages.more,
                                                  height: 3.8 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  width: 3.8 *
                                                      SizeConfig
                                                          .heightMultiplier,
                                                  color: white,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                              ],
                            );
                          }),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          Gap(0.5 * SizeConfig.heightMultiplier),
                      itemCount: postState.posts.length,
                    );
                  default:
                    return LoadingCircle();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
