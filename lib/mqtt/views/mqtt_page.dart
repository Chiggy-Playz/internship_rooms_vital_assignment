import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_handler/mqtt_handler.dart';
import 'package:rooms_vital_assignment/mqtt/mqtt.dart';

class MqttPage extends StatelessWidget {
  const MqttPage({super.key});

  static const String routePath = "/mqtt";
  static const String routeName = "mqtt";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MqttBloc(handler: context.read<MqttHandler>()),
      child: const MqttView(),
    );
  }
}
