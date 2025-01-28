import 'package:authentication_client/authentication_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_handler/mqtt_handler.dart';
import 'package:rooms_vital_assignment/app/app.dart';
import 'package:rooms_vital_assignment/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authenticationClient = AuthenticationClient();
  final mqttClient = MqttServerClient.withPort("broker.hivemq.com", '__chiggy__roomsvital__', 1883);
  final mqttHandler = MqttHandler(client: mqttClient);

  runApp(
    App(
      authenticationClient: authenticationClient,
      user: await authenticationClient.user.first,
      mqttHandler: mqttHandler,
    ),
  );
}
