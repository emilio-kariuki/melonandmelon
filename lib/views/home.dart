import 'package:flutter/services.dart';
import 'package:melonandmelon/blocs/app/user_cubit.dart';
import 'package:melonandmelon/blocs/minimal/navigation_cubit.dart';
import 'package:melonandmelon/data/repository/auth_repository.dart';
import 'package:melonandmelon/shared/image_containe.dart';
import 'package:melonandmelon/utilities/packages.dart';

class Home extends StatefulWidget {
  final Widget child;
  const Home({super.key, required this.child});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> routes = [
    '/home',
    '/search',
    '/add',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(8 * SizeConfig.heightMultiplier),
        child: AppBar(
          title: Row(
            children: [
              SvgPicture.asset(
                AppImages.menu,
                height: 3 * SizeConfig.heightMultiplier,
                width: 3 * SizeConfig.heightMultiplier,
                color: lightGrey,
              ),
              const Spacer(),
              Gap(2.5 * SizeConfig.widthMultiplier),
              Text(
                APP_NAME,
                style: GoogleFonts.pacifico(
                  color: lightGrey,
                  fontSize: 2.5 * SizeConfig.textMultiplier,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                AppImages.message,
                height: 3 * SizeConfig.heightMultiplier,
                width: 3 * SizeConfig.heightMultiplier,
                color: lightGrey,
              ),
              Gap(2.5 * SizeConfig.widthMultiplier),
              BlocBuilder<UserCubit, UserState>(
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () => context.push(Routes.profile),
                    child: ImageContainer(
                      imageUrl: state.user?.image ?? AppImages.defaultImage,
                      height: 5 * SizeConfig.heightMultiplier,
                      width: 5 * SizeConfig.heightMultiplier,
                      isCirlce: true,
                    ),
                  );
                },
              )
            ],
          ),
          centerTitle: true,
          backgroundColor: black,
          surfaceTintColor: black,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
        ),
      ),
      backgroundColor: white,
      body: BlocProvider(
        create: (context) => NavigationCubit()..changePage(page: 0),
        child: BlocConsumer<NavigationCubit, NavigationState>(
          listener: (context, state) {
            appRouter.go(routes[state.page]);
          },
          builder: (context, state) {
            return Stack(
              children: [
                widget.child,
                Positioned.fill(
                    bottom: MediaQuery.of(context).size.height * 0.02,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                context
                                    .read<NavigationCubit>()
                                    .changePage(page: 0);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                surfaceTintColor: Colors.transparent,
                                foregroundColor: white,
                                side: BorderSide.none,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color:
                                      state.page == 0 ? darkWhite : lightDark,
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  AppImages.home,
                                  height: 2.8 * SizeConfig.heightMultiplier,
                                  width: 2.8 * SizeConfig.heightMultiplier,
                                  color: state.page == 0 ? lightDark : white,
                                ),
                              ),
                            ),
                            Gap(1 * SizeConfig.widthMultiplier),
                            // OutlinedButton(
                            //   onPressed: () {
                            //     context
                            //         .read<NavigationCubit>()
                            //         .changePage(page: 1);
                            //   },
                            //   style: OutlinedButton.styleFrom(
                            //     padding: EdgeInsets.zero,
                            //     backgroundColor: Colors.transparent,
                            //     surfaceTintColor: Colors.transparent,
                            //     foregroundColor: white,
                            //     side: BorderSide.none,
                            //   ),
                            //   child: Container(
                            //     padding: const EdgeInsets.all(18),
                            //     decoration: BoxDecoration(
                            //       color:
                            //           state.page == 1 ? darkWhite : lightDark,
                            //       shape: BoxShape.circle,
                            //     ),
                            //     child: SvgPicture.asset(
                            //       AppImages.search,
                            //       height: 2.8 * SizeConfig.heightMultiplier,
                            //       width: 2.8 * SizeConfig.heightMultiplier,
                            //       color: state.page == 1 ? lightDark : white,
                            //     ),
                            //   ),
                            // ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<NavigationCubit>()
                                    .changePage(page: 2);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: const BoxDecoration(
                                  color: green,
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(
                                  AppImages.add,
                                  height: 2.8 * SizeConfig.heightMultiplier,
                                  width: 2.8 * SizeConfig.heightMultiplier,
                                  color: black,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ))
              ],
            );
          },
        ),
      ),
    );
  }
}
