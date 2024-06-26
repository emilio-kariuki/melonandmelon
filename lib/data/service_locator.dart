import 'package:melonandmelon/data/provider/auth_provider.dart';
import 'package:melonandmelon/data/provider/notification_provider.dart';
import 'package:melonandmelon/data/provider/post_provider.dart';
import 'package:melonandmelon/data/provider/user_provider.dart';
import 'package:melonandmelon/data/repository/auth_repository.dart';
import 'package:melonandmelon/data/repository/notification_repository.dart';
import 'package:melonandmelon/data/repository/post_repository.dart';
import 'package:melonandmelon/data/repository/user_repository.dart';
import 'package:get_it/get_it.dart';

final service = GetIt.instance;

void initLocator() {
  service
    ..registerLazySingleton<AuthProvider>(
        () => AuthProvider(authRepository: service()))
    ..registerLazySingleton<AuthRepository>(() => AuthRepository())
    ..registerLazySingleton<NotificationProvider>(
        () => NotificationProvider(notificationRepository: service()))
    ..registerLazySingleton<NotificationRepository>(
        () => NotificationRepository())
    ..registerLazySingleton<UserProvider>(
        () => UserProvider(userRepository: service()))
    ..registerLazySingleton<UserRepository>(() => UserRepository())
    ..registerLazySingleton<PostProvider>(
        () => PostProvider(postRepository: service()))
    ..registerLazySingleton<PostRepository>(() => PostRepository())
    ;
}
