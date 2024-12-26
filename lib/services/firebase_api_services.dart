import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApiServices {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    //used to test the notifications if they work.
    final fcmToken = await _firebaseMessaging.getToken();
    print('Token is this:  $fcmToken');
    // the notifications are sceduled everyday at 11:06 from firebase message campaigns.
  }  
}
