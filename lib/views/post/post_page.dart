import 'package:flutter/services.dart';
import 'package:melonandmelon/blocs/app/app_cubit.dart';
import 'package:melonandmelon/blocs/app/post_cubit.dart';
import 'package:melonandmelon/blocs/app/user_cubit.dart';
import 'package:melonandmelon/main.dart';
import 'package:melonandmelon/models/post_request.dart';
import 'package:melonandmelon/shared/image_containe.dart';
import 'package:melonandmelon/shared/loading_circle.dart';
import 'package:melonandmelon/utilities/packages.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _postController = TextEditingController();
  List<String> _images = [];

  @override
  void dispose() {
    super.dispose();
    _postController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: black,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AppCubit(),
          ),
         
        ],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () {},
                        child: ImageContainer(
                          imageUrl: state.user?.image ?? AppImages.defaultImage,
                          height: 6 * SizeConfig.heightMultiplier,
                          width: 6 * SizeConfig.heightMultiplier,
                          isCirlce: true,
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  BlocConsumer<AppCubit, AppState>(
                    listener: (context, state) {
                      if (state.status == AppStatus.uploaded) {
                        _images.add(state.imageUrl);
                        logger.i(_images);
                      }
                      if (state.status == AppStatus.success) {
                        context.read<AppCubit>().uploadImage();
                      }
                    },
                    builder: (context, state) {
                      return OutlinedButton(
                        onPressed: () => context
                            .read<AppCubit>()
                            .pickImage(source: ImageSource.gallery),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          foregroundColor: white,
                          side: BorderSide.none,
                        ),
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: green,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Text('Upload',
                                style: GoogleFonts.inter(
                                  color: black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ))),
                      );
                    },
                  ),
                  Gap(2 * SizeConfig.heightMultiplier),
                  BlocConsumer<PostCubit, PostState>(
                    listener: (context, state) {
                      if (state.status == PostStatus.created) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Post created successfully'),
                          ),
                        );
                        context
                          ..read<PostCubit>().getPosts()
                          ..go('/home');
                      }
                    },
                    builder: (context, state) {
                      return OutlinedButton(
                        onPressed: () {
                          context.read<PostCubit>().createPost(
                                  post: PostRequestModel(
                                content: _postController.text,
                                image: _images,
                              ));
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          foregroundColor: white,
                          side: BorderSide.none,
                        ),
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: green,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: state.status == PostStatus.loading
                                ? const LoadingCircle()
                                : Text('Post',
                                    style: GoogleFonts.inter(
                                      color: black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ))),
                      );
                    },
                  ),
                ],
              ),
            ),
            Gap(2 * SizeConfig.heightMultiplier),
            TextFormField(
              controller: _postController,
              style: GoogleFonts.inter(
                color: lightGrey,
                fontSize: 13,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 20,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Just a thought...',
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xff777777),
                  fontSize: 13,
                ),
                fillColor: Colors.transparent,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            Gap(2 * SizeConfig.heightMultiplier),
            BlocBuilder<AppCubit, AppState>(
              builder: (context, state) {
                return SizedBox(
                  height: 15 * SizeConfig.heightMultiplier,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          left: index == 0 ? 10 : 0,
                          right: index == _images.length - 1 ? 10 : 0,
                        ),
                        child: ImageContainer(
                          imageUrl: _images[index],
                          height: 15 * SizeConfig.heightMultiplier,
                          width: 15 * SizeConfig.heightMultiplier,
                          isCirlce: false,
                          borderRadius: BorderRadius.circular(25),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        Gap(1 * SizeConfig.heightMultiplier),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
