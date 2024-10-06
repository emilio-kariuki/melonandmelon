import 'package:melonandmelon/blocs/app/post_cubit.dart';
import 'package:melonandmelon/shared/loading_circle.dart';
import 'package:melonandmelon/utilities/packages.dart';
import 'components/image_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, postState) {
          if(postState.status == PostStatus.loading || postState.status == PostStatus.initial){
            return const LoadingCircle(size: 50,);
          }else if(postState.status == PostStatus.error){
            return const LoadingCircle(size: 50,);
          }
          return ListView.separated(
                cacheExtent: 1000,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final posts = context.read<PostCubit>().state.posts;
                  final post = posts[index];
                  return ImageSection(post: post, index: index);
                },
                separatorBuilder: (_, __) =>
                    Gap(0.1 * SizeConfig.heightMultiplier),
                itemCount: context.read<PostCubit>().state.posts.length,
              );
            
        },
      ),
    );
  }
}

