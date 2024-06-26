
import 'package:melonandmelon/utilities/packages.dart';

abstract class NotificationTemplate {
    Future<void> initializeNotifications();
    Future<void> sendNotification({required String title, required String body});
    Future<String> getNotificationToken();
}

class NotificationRepository extends NotificationTemplate {
    late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    late AndroidNotificationChannel channel;
    NotificationRepository() {
        flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

        channel = const AndroidNotificationChannel(
        'low_importance_channel',
        'Low Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        );
        var initializationSettingsAndroid =
            const AndroidInitializationSettings('melonandmelon');
        var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: const DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: false,
        ),
        );
        flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        );
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: false,
        );
    }

    @override
    Future<String> getNotificationToken() async {
        try {
        final token = await FirebaseMessaging.instance.getToken();
        debugPrint('The firebase messaging token is: $token');
        return token!;
        } catch (e) {
        debugPrint(e.toString());
        throw Exception('Error getting firebase messaging token');
        }
    }

    @override
    Future<void> initializeNotifications() async {
        try {
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
            alert: false,
            badge: true,
            sound: false,
        );
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
            debugPrint('Message received: ${message.notification!.body}');
            sendNotification(
            body: message.data['message'] ?? message.contentAvailable.toString(),
            title: message.data['title'] ?? message.notification!.title!,
            );
        });
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
            debugPrint('Message received: ${message.notification!.body}');
            sendNotification(
            body: message.data['message'] ?? message.contentAvailable.toString(),
            title: message.data['title'] ?? message.notification!.title!,
            );
        });
        } catch (e) {
        debugPrint(e.toString());
        throw Exception('Error initializing firebase messaging');
        }
    }

    @override
    Future<void> sendNotification({required String title, required String body}) {
        return flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        const NotificationDetails(
            android: AndroidNotificationDetails(
            "2",
            'normal Notifications',
            channelDescription: 'This is the notifications normal channel',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: false,
            ),
        ),
        );
    }
}