import 'package:flutter/services.dart';
import 'package:melonandmelon/blocs/app/user_cubit.dart';
import 'package:melonandmelon/shared/image_containe.dart';
import 'package:melonandmelon/shared/input_field.dart';
import 'package:melonandmelon/utilities/packages.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => UserCubit()..getUser(),
      child: Builder(builder: (context) {
        return Scaffold(
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
                  "${state.user!.username}",
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
              SvgPicture.asset(
                AppImages.more,
                height: 3.4 * SizeConfig.heightMultiplier,
                width: 3.4 * SizeConfig.heightMultiplier,
                color: white,
              ),
              Gap(1 * SizeConfig.widthMultiplier)
            ],
            centerTitle: true,
            backgroundColor: black,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            elevation: 0,
          ),
          backgroundColor: black,
          body: Column(
            children: [
              Gap(2 * SizeConfig.heightMultiplier),
              Center(
                child: ImageContainer(
                  imageUrl: AppImages.defaultImage,
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
                    "@emiliokariuki",
                    style: TextStyle(
                        fontSize: 1.9 * SizeConfig.textMultiplier,
                        fontWeight: FontWeight.w500,
                        color: white),
                  )
                ],
              ),
              Gap(1 * SizeConfig.heightMultiplier),
              
              Gap(1 * SizeConfig.heightMultiplier),
              Text(
                "Prefessional Photographer | Software Engineer",
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
                                    fontSize: 1.9 * SizeConfig.textMultiplier,
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
                                  fontSize: 1.9 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w500,
                                  color: white),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Gap(2 * SizeConfig.heightMultiplier),
              
            ],
          ),
        );
      }),
    );
  }
}

class EditProfile extends StatefulWidget {
  EditProfile({super.key,});



  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();

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
          }
        },
        builder: (context, state) {
          return Column(
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
                imageUrl: AppImages.defaultImage,
                height: size.height * 0.08,
                width: size.height * 0.08,
                isCirlce: true,
              ),
              Gap(1 * SizeConfig.heightMultiplier),
              Text(
                "Edit Picture",
                style: TextStyle(
                    fontSize: 1.6 * SizeConfig.textMultiplier,
                    fontWeight: FontWeight.w500,
                    color: green),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
              ),
              Gap(2 * SizeConfig.heightMultiplier),
              GestureDetector(
                onTap: () {
                 
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: darkGreen,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                            fontSize: 1.9 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w700,
                            color: black),
                      ),
                    )),
              ),
              Gap(3 * SizeConfig.heightMultiplier),
            ],
          );
        },
      ),
    );
  }
}
