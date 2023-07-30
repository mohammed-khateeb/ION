import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:ion_application/Models/Api/transactions.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttHandler with ChangeNotifier {
  final ValueNotifier<String> data = ValueNotifier<String>("");

  MqttServerClient? client;


  final ValueNotifier<List<Transaction>> sessionData = ValueNotifier<List<Transaction>>([]);


  Future<Object> connect(String mobileNumber) async {

    client = MqttServerClient('wss://evse.cloud', 'Mqtt_MyClientUniqueId');
    client!.useWebSocket = true;
    client!.port = 8084; // ( or whatever your ws port is)
    client!.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
    client!.logging(on: true);
    client!.connectTimeoutPeriod = 15000;
    client!.keepAlivePeriod = 20;
    client!.onDisconnected = onDisconnected;
    client!.secure = false;
    client!.onConnected = onConnected;
    client!.onSubscribed = onSubscribed;
    client!.pongCallback = pong;


    try {
      await client!.connect("mobile","edFYacwZpthjw");
    } on NoConnectionException catch (e) {
      print('EXAMPLE::client! exception - $e');
      client!.disconnect();
      exit(-1);
    } on SocketException catch (e) {
      print('EXAMPLE::socket exception - $e');
      client!.disconnect();
      exit(-1);
    } on HttpException catch (e){
      print('EXAMPLE::http exception - $e');
      client!.disconnect();
      exit(-1);
    }

    if (client!.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT_LOGS::Mosquitto client! connected');
    } else {
      print(
          'MQTT_LOGS::ERROR Mosquitto client! connection failed - disconnecting, status is ${client!.connectionStatus}');
      client!.disconnect();
      return -1;
    }

    client!.subscribe("user/$mobileNumber/session/#", MqttQos.atMostOnce);
    client!.subscribe("map/locations", MqttQos.atMostOnce);


    client!.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final id = c[0].topic.split("session/").last;
      print("/////////////////$id");
      final pt =
      utf8.decode(recMess.payload.message);

      if(c[0].topic == "map/locations"){
        data.value = utf8.decode(recMess.payload.message);
        print(
            'MQTT_LOGS_MAP:: New data arrived: topic is <${c[0].topic}>, payload is ${pt}');

        print(data.value);
      }

      else{
        if(pt.isNotEmpty){
          Transaction transaction = Transaction.fromJson(jsonDecode(pt));
          transaction.mqttTopic = c[0].topic.split("session/").last;
          Transaction? oldTransactions = sessionData.value.firstWhereOrNull((element) => element.mqttTopic==transaction.mqttTopic);
          if(oldTransactions!=null){
            sessionData.value.removeWhere((element) => element.mqttTopic==transaction.mqttTopic);
            oldTransactions = Transaction.fromJson(jsonDecode(pt));
            oldTransactions.mqttTopic = transaction.mqttTopic;
            sessionData.value.add(oldTransactions);
          }
          else{
            sessionData.value.add(transaction);
          }
        }
        else{
          sessionData.value.removeWhere((element) => element.mqttTopic == id);
          print('Session topic :: Subtopic deleted');

        }
        print('session topic MQTT_LOGS:: New data arrived: topic is <${c[0].topic}>, payload is $pt');

        print(sessionData.value.map((e) => e.toJson()));


      }

      notifyListeners();
    });

    return client!;
  }


  void disconnectMqtt() {
    try {
      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        client!.disconnect();
        print("Disconnected from MQTT broker.");
      } else {
        print("Not connected to MQTT broker.");
      }
    } catch (e) {
      print("Error disconnecting from MQTT broker: $e");
    }
  }









  void onConnected() {
    print('MQTT_LOGS:: Connected');
  }

  void onDisconnected() {
    print('MQTT_LOGS:: Disconnected');
  }

  void onSubscribed(String topic) {
    print('MQTT_LOGS:: Subscribed topic: $topic');
  }

  void onSubscribeFail(String topic) {
    print('MQTT_LOGS:: Failed to subscribe $topic');
  }

  void onUnsubscribed(String? topic) {
    print('MQTT_LOGS:: Unsubscribed topic: $topic');
  }

  void pong() {
    print('MQTT_LOGS:: Ping response client! callback invoked');
  }

}