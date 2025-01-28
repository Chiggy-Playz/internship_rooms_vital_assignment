// ignore_for_file: avoid_print

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttHandler {
  final MqttServerClient _client;

  MqttHandler({required MqttServerClient client}) : _client = client {
    _client.logging(on: true);
    _client.onConnected = onConnected;
    _client.onDisconnected = onDisconnected;
    _client.onUnsubscribed = onUnsubscribed;
    _client.onSubscribed = onSubscribed;
    _client.onSubscribeFail = onSubscribeFail;
    _client.pongCallback = pong;
    _client.keepAlivePeriod = 60;
    _client.logging(on: true);
    _client.setProtocolV311();
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>> get updates =>
      _client.updates!;

  Future<void> connect() async {
    final connMessage = MqttConnectMessage()
        .withWillTopic('chiggy_willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    _client.connectionMessage = connMessage;
    try {
      await _client.connect();
    } catch (e) {
      print('couldnnt connect Exception: $e');
      _client.disconnect();
    }

    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT_LOGS::Mosquitto _client connected');
    } else {
      print(
          'MQTT_LOGS::ERROR Mosquitto _client connection failed - disconnecting, status is ${_client.connectionStatus}');
      _client.disconnect();
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
    print('MQTT_LOGS:: Ping response client callback invoked');
  }

  void subscribe(String topic) {
    print('MQTT_LOGS::Subscribing to the "$topic" topic');
    _client.subscribe(topic, MqttQos.atMostOnce);
  }
}
