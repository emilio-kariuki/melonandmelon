import 'package:melonandmelon/blocs/app/app_cubit.dart';
import 'package:melonandmelon/blocs/app/user_cubit.dart';
import 'package:melonandmelon/shared/image_container.dart';
import 'package:melonandmelon/shared/loading_circle.dart';
import 'package:melonandmelon/utilities/packages.dart';

class EditProfile extends StatefulWidget {
 const EditProfile({
    super.key,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();

  String _imageUrl = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      width: size.width,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: BlocConsumer<UserCubit, UserState>(
        bloc: context.read<UserCubit>()..getUser(),
        listener: (context, state) {
          if (state.status == UserStatus.success) {
            _usernameController.text = state.user!.username;
            _bioController.text = state.user!.bio;
            _nameController.text = state.user!.name;
            _imageUrl = state.user!.image;
          }
        },
        builder: (context, state) {
          return IntrinsicHeight(
            child:state.status == UserStatus.loading
              ? SizedBox(
                height: size.height * 0.5,
                child: const Center(
                    child: LoadingCircle(),
                  ),
              )
              :  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Gap(2 * SizeConfig.heightMultiplier),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: size.height * 0.003,
                            width: size.width * 0.2,
                            decoration: BoxDecoration(
                              color: const Color(0xff777777),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ],
                      ),
                      Gap(2 * SizeConfig.heightMultiplier),
                      Row(
                        children: [
                          Text(
                            "Edit Profile",
                            style: TextStyle(
                                fontSize: 2 * SizeConfig.textMultiplier,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 109, 109, 109)),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: SvgPicture.asset(
                              AppImages.close,
                              height: 2.5 * SizeConfig.heightMultiplier,
                              width: 2.5 * SizeConfig.heightMultiplier,
                              color: const Color.fromARGB(255, 109, 109, 109),
                            ),
                          ),
                        ],
                      ),
                      Gap(3 * SizeConfig.heightMultiplier),
                      ImageContainer(
                        imageUrl: _imageUrl,
                        height: size.height * 0.08,
                        width: size.height * 0.08,
                        isCirlce: true,
                      ),
                      Gap(1 * SizeConfig.heightMultiplier),
                      BlocProvider(
                        create: (context) => AppCubit(),
                        child: BlocConsumer<AppCubit, AppState>(
                          listener: (context, state) {
                            if (state.status == AppStatus.uploaded) {
                              _imageUrl = state.imageUrl;
                            }
                            if (state.status == AppStatus.success) {
                              context.read<AppCubit>().uploadImage();
                            }
                          },
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () => context
                                  .read<AppCubit>()
                                  .pickImage(source: ImageSource.gallery),
                              child: Text(
                                "Edit Picture",
                                style: TextStyle(
                                    fontSize: 1.6 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w500,
                                    color: green),
                              ),
                            );
                          },
                        ),
                      ),
                      Gap(2 * SizeConfig.heightMultiplier),
                      TextFormField(
                        controller: _nameController,
                        style: TextStyle(
                          color: lightGrey,
                          fontSize: 1.7 * SizeConfig.textMultiplier,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            color: const Color(0xff777777),
                            fontSize: 1.7 * SizeConfig.textMultiplier,
                          ),
                          fillColor: const Color(0xff232323),
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                      Gap(1 * SizeConfig.heightMultiplier),
                      TextFormField(
                        controller: _usernameController,
                        style: TextStyle(
                          color: lightGrey,
                          fontSize: 1.7 * SizeConfig.textMultiplier,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            color: const Color(0xff777777),
                            fontSize: 1.7 * SizeConfig.textMultiplier,
                          ),
                          fillColor: const Color(0xff232323),
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                      Gap(1 * SizeConfig.heightMultiplier),
                      TextFormField(
                        controller: _bioController,
                        style: TextStyle(
                          color: lightGrey,
                          fontSize: 1.7 * SizeConfig.textMultiplier,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Bio',
                          hintStyle: TextStyle(
                            color: const Color(0xff777777),
                            fontSize: 1.7 * SizeConfig.textMultiplier,
                          ),
                          fillColor: const Color(0xff232323),
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(5)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                        ),
                      ),
                      Gap(2 * SizeConfig.heightMultiplier),
                      BlocConsumer<UserCubit, UserState>(
                        listener: (context, state) {
                          if (state.status == UserStatus.updated) {
                            context
                              ..read<UserCubit>().getUser()
                              ..showSuccessSnackBar(message: state.message)
                              ..pop();
                          }
            
                          if (state.status == UserStatus.error) {
                            context.showErrorSnackBar(message: state.message);
                          }
                        },
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              final user = state.user!.copyWith(
                                name: _nameController.text,
                                username: _usernameController.text,
                                bio: _bioController.text,
                                image: _imageUrl,
                              );
                              context.read<UserCubit>().updateUser(user: user);
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: darkGreen,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: state.status == UserStatus.loading
                                    ? const LoadingCircle(
                                        size: 25,
                                        color: white,
                                      )
                                    : Center(
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                              fontSize:
                                                  1.9 * SizeConfig.textMultiplier,
                                              fontWeight: FontWeight.w700,
                                              color: black),
                                        ),
                                      )),
                          );
                        },
                      ),
                      Gap(3 * SizeConfig.heightMultiplier),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
