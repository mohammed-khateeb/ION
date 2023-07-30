import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../Utils/color_utils.dart';

class PushNotificationServices {
  static String? fcmToken;
  static String fcmKey = '';
  static final flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();



  static initLocalNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('logo');

    //Initialization Settings for iOS
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    return Future<void>.value();
  }


  static showNotification(String title, String message) async {
    AndroidNotificationDetails _androidNotificationDetails =
    const AndroidNotificationDetails(
      'channel ID', 'channel name',
      importance: Importance.max,
      playSound: true,
      priority: Priority.high,
      fullScreenIntent: true,
      icon: "logo",


    );

    DarwinNotificationDetails _iosNotificationDetails =
    const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        badgeNumber: 1);

    var platform = NotificationDetails(
        android: _androidNotificationDetails, iOS: _iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      platform,
      payload: 'PushNotification Payload',
    );
  }

  static void sendMessageToAnyUser({required String title,required String body,required String to}) async {
    await http.post( Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$fcmKey'
        },
        body: jsonEncode({
          'notification': <String, dynamic>{
            'title': title,
            'body': body,
            'sound': 'true'
          },

          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': to
        })).whenComplete(() {
    }).catchError((e) {
      debugPrint('error: $e');
    });
  }


}