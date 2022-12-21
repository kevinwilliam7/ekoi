import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:smart_aquarium/services/local_notification_service.dart';

class OneSignalService {
  Future<void> initialize() async {
    OneSignal.shared.setLogLevel(OSLogLevel.none, OSLogLevel.none);
    await OneSignal.shared.setAppId('8d35d4ca-fe48-407c-abc9-3af3657668cb');
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {});
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) async {
      // LocalNotificationService().showLocalNotif(
      //   id: event.hashCode,
      //   body: event.notification.body.toString(),
      //   title: event.notification.title.toString(),
      // );
    });
  }
}
