import 'package:melonandmelon/blocs/app/post_cubit.dart';
import 'package:melonandmelon/shared/image_container.dart';
import 'package:melonandmelon/utilities/packages.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: black,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _searchController,
                style: GoogleFonts.inter(
                  color: lightGrey,
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: GoogleFonts.inter(
                    color: const Color(0xff777777),
                    fontSize: 13,
                  ),
                  fillColor: const Color(0xff232323),
                  filled: true,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SvgPicture.asset(
                      AppImages.search,
                      color: const Color(0xff777777),
                      height: 15,
                      width: 15,
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),            
              // Gap(2 * SizeConfig.heightMultiplier),
              // Text(
              //   'Trending',
              //   style: TextStyle(
              //     color: lightGrey,
              //     fontSize: 2.2 * SizeConfig.textMultiplier,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
          
              Gap(2 * SizeConfig.heightMultiplier),
               Text(
                'Recommended for you',
                style: TextStyle(
                  color: lightGrey,
                  fontSize: 2.2 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(2 * SizeConfig.heightMultiplier),
              BlocConsumer<PostCubit, PostState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, postState) {
                  return GridView.builder(
                    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0.7 * SizeConfig.widthMultiplier,
                        mainAxisSpacing: 0.7 * SizeConfig.widthMultiplier,
                        childAspectRatio: 0.95,
                        ),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ImageContainer(
                              imageUrl: postState.posts[index].image![0],
                              height: size.height * 0.8,
                              width: size.width,
                              borderRadius: BorderRadius.circular(25)),
                              Positioned(
                                bottom: 0,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        children: [
                                          ImageContainer(
                                            imageUrl: postState.posts[index].user?.image ??
                                                AppImages.defaultImage,
                                            height: size.height * 0.04,
                                            width: size.height * 0.04,
                                            isCirlce: true,
                                          ),
                                          Gap(1.5*
                                              SizeConfig.widthMultiplier),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                postState.posts[index].user!.name,
                                                style: TextStyle(
                                                  fontSize: 1.6 *
                                                      SizeConfig
                                                          .textMultiplier,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  color: darkWhite,
                                                  height: 1
                                                ),
                                              ),
                                              Text(
                                                postState
                                                    .posts[index].createdAt
                                                    .toString()
                                                    .timeAgo(),
                                                style: TextStyle(
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
                                    ),
                                  ),
                                ))
                        ],
                      );
                    },
                    itemCount: postState.posts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
