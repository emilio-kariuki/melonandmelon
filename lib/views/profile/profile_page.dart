import 'package:flutter/services.dart';
import 'package:melonandmelon/blocs/app/post_cubit.dart';
import 'package:melonandmelon/blocs/app/user_cubit.dart';
import 'package:melonandmelon/shared/image_container.dart';
import 'package:melonandmelon/utilities/packages.dart';
import 'package:melonandmelon/views/profile/components/profile_drawer.dart';

import 'components/edit_profile.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => UserCubit()..getUser(),
      child: Builder(builder: (context) {
        return Scaffold(
          key: _key,
          drawer: const ProfileDrawer(),
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state.status == UserStatus.loading ||
                    state.status == UserStatus.error ||
                    state.status == UserStatus.initial) {
                  return Text(
                    "Loading...",
                    style: TextStyle(
                        fontSize: 1.9 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w500,
                        color: white),
                  );
                }
                return Text(
                  state.user!.username,
                  style: TextStyle(
                      fontSize: 1.9 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w500,
                      color: white),
                );
              },
            ),
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: white,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => _key.currentState!.openDrawer(),
                child: SvgPicture.asset(
                  AppImages.more,
                  height: 3.4 * SizeConfig.heightMultiplier,
                  width: 3.4 * SizeConfig.heightMultiplier,
                  color: white,
                ),
              ),
              Gap(2 * SizeConfig.widthMultiplier)
            ],
            centerTitle: true,
            backgroundColor: black,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            elevation: 0,
          ),
          backgroundColor: black,
          body: SingleChildScrollView(
            child: BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                var user = state.user;
                return Column(
                  children: [
                    Gap(2 * SizeConfig.heightMultiplier),
                    Center(
                      child: ImageContainer(
                        imageUrl: user?.image ?? AppImages.defaultImage,
                        height: size.height * 0.16,
                        width: size.height * 0.16,
                        isCirlce: true,
                      ),
                    ),
                    Gap(1 * SizeConfig.heightMultiplier),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(AppImages.verified),
                        Gap(1 * SizeConfig.widthMultiplier),
                        Text(
                          user?.username ?? "",
                          style: TextStyle(
                              fontSize: 1.9 * SizeConfig.textMultiplier,
                              fontWeight: FontWeight.w500,
                              color: white),
                        )
                      ],
                    ),
                    Gap(1 * SizeConfig.heightMultiplier),
                    Text(
                      user?.bio ?? "",
                      style: TextStyle(
                        fontSize: 1.7 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 123, 122, 122),
                      ),
                    ),
                    Gap(2 * SizeConfig.heightMultiplier),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => EditProfile()),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff232323),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                          fontSize:
                                              1.9 * SizeConfig.textMultiplier,
                                          fontWeight: FontWeight.w500,
                                          color: white),
                                    ),
                                  )),
                            ),
                          ),
                          Gap(2 * SizeConfig.widthMultiplier),
                          Expanded(
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xff232323),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    "Share Profile",
                                    style: TextStyle(
                                        fontSize:
                                            1.9 * SizeConfig.textMultiplier,
                                        fontWeight: FontWeight.w500,
                                        color: white),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                    Gap(2 * SizeConfig.heightMultiplier),
                    BlocBuilder<PostCubit, PostState>(
                      builder: (context, state) {
                        final posts = context.read<PostCubit>().state.posts;
                        return GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: posts.length,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing:
                                        0.2 * SizeConfig.heightMultiplier,
                                    crossAxisSpacing:
                                        0.2 * SizeConfig.heightMultiplier),
                            itemBuilder: (context, index) {
                              return ImageContainer(
                                imageUrl: posts[index].image?[0] ??
                                    AppImages.defaultImage,
                                height: size.height * 0.4,
                                width: size.height * 0.4,
                                isCirlce: false,
                              );
                            });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
