import 'package:melonandmelon/blocs/app/user_cubit.dart';
import 'package:melonandmelon/shared/image_container.dart';
import 'package:melonandmelon/utilities/packages.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        backgroundColor: black,
        appBar: AppBar(
          backgroundColor: black,
          elevation: 0,
          leading: GestureDetector(
              onTap: () => context.pop(),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: white,
              ),
            ),
          title: Text(
                    "Settings and Activity",
                    style: GoogleFonts.notoSans(
                      color: white,
                      fontSize: 1.8 * SizeConfig.textMultiplier,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        ),
        body: SafeArea(child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const Gap(2),
              
              const Spacer(),
              ListTile(
                onTap: () {},
                title:  Text(
                  'Logout',
                  style: GoogleFonts.notoSans(
                    color: red,
                    fontSize: 1.8 * SizeConfig.textMultiplier,
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
