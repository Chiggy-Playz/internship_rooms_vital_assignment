import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rooms_vital_assignment/core/extensions.dart';
import 'package:rooms_vital_assignment/mqtt/mqtt.dart';

class MqttView extends StatefulWidget {
  const MqttView({super.key});

  @override
  State<MqttView> createState() => _MqttViewState();
}

class _MqttViewState extends State<MqttView> {
  @override
  void initState() {
    super.initState();
    context.read<MqttBloc>().add(MqttConnect());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MqttBloc, MqttState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is MqttInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is MqttLoaded) {
          return Column(
            children: [
              Text(
                "Subscribed to: 'chiggy_testing' topic",
                style: context.textTheme.titleLarge,
              ),
              const Divider(),
              if (state.messages.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];

                      return Card(
                        child: ListTile(
                          title: Text(message),
                        ),
                      );
                    },
                  ),
                )
              else
                const Text("No messages received...")
            ],
          );
        }

        throw Exception("Oops");
      },
    );
  }
}
