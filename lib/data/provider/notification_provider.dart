
import 'package:melonandmelon/data/repository/notification_repository.dart';

class NotificationProvider extends NotificationTemplate {
    final NotificationRepository _notificationRepository;
    NotificationProvider({required NotificationRepository notificationRepository})
        : _notificationRepository = notificationRepository;

    @override
    Future<String> getNotificationToken() {
        return _notificationRepository.getNotificationToken();
    }

    @override
    Future<void> initializeNotifications() {
        return _notificationRepository.initializeNotifications();
    }

    @override
    Future<void> sendNotification({required String title, required String body}) {
        return _notificationRepository.sendNotification(title: title, body: body);
    }
}
